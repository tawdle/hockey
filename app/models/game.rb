class Game < ActiveRecord::Base
  include AsyncMessaging

  state_machine :initial => :scheduled do
    event :activate do
      transition :scheduled => :active
    end

    event :start do
      transition [:active, :paused] => :playing
    end

    event :pause do
      transition :playing => :paused
    end

    event :stop do
      transition :playing => :active
    end

    event :finish do
      transition :active => :finished
    end

    event :complete do
      transition :finished => :completed
    end

    event :cancel do
      transition :scheduled => :canceled
    end

    after_transition any => :canceled, :do => :generate_cancel_feed_item
    before_transition :scheduled => :active, :do => :create_clock
    after_transition :scheduled => :active, :do => :generate_game_started_feed_item
    after_transition :active => :playing, :do => :set_next_period
    after_transition any => :completed, :do => :destroy_clock
    after_transition any => :completed, :do => :generate_game_over_feed_item
    after_transition any => any, :do => :broadcast_changes_from_state_machine
    after_transition any => :playing, :do => :start_paused_penalties
    after_transition any => [:paused, :active, :finished], :do => :pause_running_penalties

    state all - :scheduled do
      validate {|game| game.send(:schedule_not_changed) }
    end

    state any - :scheduled do
      validate {|game| game.send(:location_not_changed) }
    end
  end

  belongs_to :home_team, :class_name => 'Team'
  belongs_to :visiting_team, :class_name => 'Team'
  belongs_to :location
  belongs_to :clock, :class_name => "Timer", :dependent => :destroy

  has_many :activity_feed_items
  has_many :goals, :inverse_of => :game
  has_many :penalties, :inverse_of => :game
  has_many :game_players, :inverse_of => :game
  has_many :players, :through => :game_players
  has_many :game_officials, :inverse_of => :game
  has_many :officials, :through => :game_officials
  has_many :referee_game_officials, :class_name => "GameOfficial", :conditions => {:role => :referee  }
  has_many :referees, :through => :referee_game_officials, :source => :official
  has_many :linesman_game_officials, :class_name => "GameOfficial", :conditions => {:role => :linesman }, :autosave => false
  has_many :linesmen, :through => :linesman_game_officials, :source => :official, :autosave => false

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start_time
  validate :start_time_is_in_future, :if => :start_time_changed?

  accepts_nested_attributes_for :game_players, :allow_destroy => true

  attr_accessor :updater
  attr_accessible :status, :home_team, :home_team_id, :visiting_team, :visiting_team_id, :location, :location_id,
    :start_time, :updater, :player_ids, :period_duration, :period_minutes, :game_players_attributes,
    :referee_ids, :linesman_ids
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :for_league, lambda {|league| joins("INNER JOIN teams h on home_team_id = h.id").joins("INNER JOIN teams v on visiting_team_id = v.id").where("h.league_id = ? or v.league_id = ?", league.id, league.id) }
  scope :scheduled, where(:state => :scheduled)
  scope :due, lambda { where("start_time < ?", DateTime.now) }
  scope :active, where(:state => [:active, :paused, :playing])
  scope :upcoming, lambda { where("start_time > ?", DateTime.now) }
  scope :scheduled_or_active, where(:state => [:scheduled, :active])
  scope :finished, where(:state => :finished)
  scope :asc, order("start_time ASC")
  scope :desc, order("start_time DESC")

  before_create :generate_create_feed_item
  before_update :generate_update_feed_item

  Periods = %w(1 2 3 OT OT2 OT3)

  LiveStates = %w(active playing paused finished)

  def start
    clock.reset unless paused?
    clock.start
    super
  end

  def stop
    # Beware the return value here; returning false kills the state transition.
    clock.pause
    if super
      if game_over?
        finish
      else
        true
      end
    end
  end

  def pause
    clock.pause
    super
  end

  def faye_uri
    AsyncMessaging::FAYE_CONFIG[:uri]
  end

  def live?
    LiveStates.include?(state)
  end

  def elapsed_time
    clock ? clock.elapsed_time : nil
  end

  def teams
    [home_team, visiting_team]
  end

  def opposing_team(team)
    team == home_team ? visiting_team : home_team
  end

  def score_for(team)
    goals.for_team(team).count
  end

  def home_team_score
    score_for(home_team)
  end

  def visiting_team_score
    score_for(visiting_team)
  end

  def score_for_opposing_team(team)
    score_for(opposing_team(team))
  end

  def score_board
    data = goals.group(:period, :team_id).order(:period).select("period, team_id, count(*)").all
    results = {}
    teams.each do |team|
      results[team.name] = Game::Periods.map do |period|
        data.find {|d| d.team_id == team.id && d.period == period }.try(:count).try(:to_i) || 0
      end
    end
    results[:total] = Game::Periods.map do |period|
      data.select {|d| d.period == period }.sum {|d| d.count.to_i }
    end

    Hash[results.map {|k,v| [k, v.append(v.sum)] }]
  end

  def period_text
    Periods[period || 0]
  end

  def reset_game_clock
    clock.reset!
  end

  def timer_expired(timer_id)
    stop
  end

  def tied?
    home_team_score == visiting_team_score
  end

  def overtime?
    period_text.starts_with?("OT")
  end

  def game_over?
    period >= 2 && !tied?
  end

  def period_minutes
    period_duration / 60
  end

  def period_minutes=(val)
    self.period_duration = val.to_i * 60
  end

  def possible_officials
    (home_team.league.officials + visiting_team.league.officials).sort_by(&:name).uniq
  end

  private

  def updater_name
    updater.try(:at_name) || "The System"
  end

  def generate_create_feed_item
    activity_feed_items.build(:message => "#{updater_name} scheduled a game between @#{home_team.name} and @#{visiting_team.name}.")
  end

  def generate_cancel_feed_item
    activity_feed_items.create!(:message => "#{updater_name} canceled a game between @#{home_team.name} and @#{visiting_team.name}.")
  end

  def generate_update_feed_item
    activity_feed_items.create!(:message => "#{updater_name} changed the scheduled start time for a game between @#{home_team.name} and @#{visiting_team.name}.") if start_time_changed?
    activity_feed_items.create!(:message => "#{updater_name} changed the location of a game between @#{home_team.name} and @#{visiting_team.name}.") if location_id_changed?
  end

  def generate_game_started_feed_item
    activity_feed_items.create!(:message => "The game between @#{home_team.name} and @#{visiting_team.name} started.")
  end

  def generate_game_over_feed_item
    activity_feed_items.create!(:message => "The between @#{home_team.name} and @#{visiting_team.name} ended.")
  end

  def pause_running_penalties
    penalties.running.each do |penalty|
      penalty.pause!
    end
  end

  def start_paused_penalties
    penalties.paused.each do |penalty|
      penalty.start!
    end
  end

  def set_next_period
    update_attribute(:period, period ? period + 1 : 0);
  end

  def create_clock
    self.clock = Timer.new(:owner => self, :duration => period_duration) unless clock
  end

  def destroy_clock
    if clock
      clock.destroy
      update_attribute(:clock_id, nil)
      self.clock = nil
    end
  end

  def home_and_visiting_teams_are_different
    errors.add(:base, "Home and visiting teams must be different") if home_team == visiting_team
  end

  def start_time_is_in_future
    errors.add(:start_time, "must be in the future") if start_time && start_time < Time.now
  end

  def schedule_not_changed
    errors.add(:start_time, "can't be changed after game starts") if start_time_changed? && persisted?
  end

  def location_not_changed
    errors.add(:location, "can't be changed after game starts") if location_id_changed? && persisted?
  end

  def broadcast_changes_from_state_machine(transition)
    broadcast_changes
  end

  def broadcast_changes(options={})
    json = active_model_serializer.new(self, options).as_json
    broadcast("/games/#{id}", json)
  end
end
