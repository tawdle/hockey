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

    event :end do
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
    after_transition any => :playing, :do => :start_game_clock!
    after_transition any => :paused, :do => :pause_game_clock!
    after_transition any => :finished, :do => :destroy_clock
    after_transition any => :completed, :do => :generate_game_over_feed_item
    after_transition any => any, :do => :broadcast_changes

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
  has_many :activity_feed_items
  has_many :goals
  has_many :penalties
  has_many :game_players
  has_many :players, :through => :game_players
  belongs_to :clock, :class_name => "Timer", :dependent => :destroy

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start_time
  validate :start_time_is_in_future, :if => :start_time_changed?

  attr_accessor :updater
  attr_accessible :status, :home_team, :home_team_id, :visiting_team, :visiting_team_id, :location, :location_id,
    :start_time, :updater, :player_ids, :period_duration, :period_minutes
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :for_league, lambda {|league| joins("INNER JOIN teams h on home_team_id = h.id").joins("INNER JOIN teams v on visiting_team_id = v.id").where("h.league_id = ? or v.league_id = ?", league.id, league.id) }
  scope :scheduled, where(:state => :scheduled)
  scope :due, lambda { where("start_time < ?", DateTime.now) }
  scope :active, where(:state => :active)
  scope :upcoming, lambda { where("start_time > ?", DateTime.now) }
  scope :scheduled_or_active, where(:state => [:scheduled, :active])
  scope :finished, where(:state => :finished)
  scope :asc, order("start_time ASC")
  scope :desc, order("start_time DESC")

  before_create :generate_create_feed_item
  before_update :generate_update_feed_item

  Periods = %w(1 2 3 OT)

  LiveStates = %w(active playing paused finished)

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

  def start_game_clock!
    clock.start!
    save!
  end

  def pause_game_clock!
    clock.pause!
  end

  def as_json(options={})
    super(options.merge(:only => [:id, :state], :methods => [:home_team_score, :visiting_team_score])).merge({:clock => clock.as_json, :fayeURI => AsyncMessaging::FAYE_CONFIG[:uri] })
  end

  def timer_expired(timer_id)
    pause
  end

  def period_minutes
    period_duration / 60
  end

  def period_minutes=(val)
    self.period_duration = val.to_i * 60
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

  def set_next_period
    self.period = period ? period + 1 : 0
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

  Uninteresting_attributes = [:updated_at, :clock_id]

  def broadcast_changes
    broadcast("/games/#{id}", as_json)
  end
end
