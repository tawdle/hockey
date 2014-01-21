class Game < ActiveRecord::Base
  include AsyncMessaging
  include SoftDelete

  state_machine :initial => :scheduled do
    event :activate do
      transition :scheduled => :ready, :if => :ready_to_activate?
      transition :active => :ready
    end

    event :start do
      transition [:ready, :paused] => :playing
    end

    event :pause do
      transition :playing => :paused
    end

    event :stop do
      transition [:ready, :playing, :paused] => :active
    end

    event :finish do
      transition [:ready, :playing, :paused, :active] => :finished
    end

    event :complete do
      transition :finished => :completed
    end

    event :cancel do
      transition :scheduled => :canceled
    end

    after_transition :ready => :playing, :do => [:generate_game_started_feed_item, :set_started_at], :if => :first_period?
    after_transition any => :finished, :do => [:set_ended_at, :finish_goalies, :terminate_penalties, :generate_game_over_feed_item]
    after_transition any => :canceled, :do => :generate_cancel_feed_item
    before_transition :scheduled => :ready, :do => :create_clock
    after_transition [:scheduled, :active] => :ready, :do => [:set_next_period, :reset_game_clock]
    after_transition any => :completed, :do => :destroy_clock
    after_transition any => any, :do => :broadcast_changes_from_state_machine
    after_transition any => :playing, :do => :start_eligible_penalties
    after_transition :playing => any, :do => :pause_running_penalties

    state all - :scheduled do
      validate {|game| game.send(:schedule_not_changed) }
    end

    state any - :scheduled do
      validate {|game| game.send(:location_not_changed) }
    end
  end

  belongs_to :league
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :visiting_team, :class_name => 'Team'
  belongs_to :location
  belongs_to :clock, :class_name => "Timer", :dependent => :destroy
  belongs_to :marker, :class_name => "User"

  has_many :activity_feed_items, :dependent => :destroy, :order => :created_at, :inverse_of => :game, :limit => 5
  has_many :goals, :inverse_of => :game, :dependent => :destroy
  has_many :penalties, :inverse_of => :game, :dependent => :destroy
  has_many :game_players, :inverse_of => :game, :dependent => :destroy
  has_many :players, :through => :game_players
  has_many :game_goalies, :class_name => "GameGoalie", :inverse_of => :game, :dependent => :destroy
  has_many :game_officials, :inverse_of => :game, :dependent => :destroy
  has_many :officials, :through => :game_officials
  has_many :referee_game_officials, :class_name => "GameOfficial", :conditions => {:role => :referee  }
  has_many :referees, :through => :referee_game_officials, :source => :official
  has_many :linesman_game_officials, :class_name => "GameOfficial", :conditions => {:role => :linesman }, :autosave => false
  has_many :linesmen, :through => :linesman_game_officials, :source => :official, :autosave => false
  has_many :game_staff_members, :dependent => :destroy
  has_many :staff_members, :through => :game_staff_members

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validates_presence_of :league
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start_time
  validate :start_time_is_in_future, :if => :start_time_changed?

  accepts_nested_attributes_for :game_players, :allow_destroy => true
  accepts_nested_attributes_for :game_staff_members, :allow_destroy => true

  attr_accessor :updater
  attr_accessible :status, :home_team, :home_team_id, :visiting_team, :visiting_team_id, :location, :location_id,
    :start_time, :updater, :player_ids, :period_durations, :period_minutes, :game_players_attributes,
    :referee_ids, :linesman_ids, :game_staff_members_attributes, :number, :current_period_duration
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :scheduled, where(:state => :scheduled)
  scope :due, lambda { where("start_time < ?", DateTime.now) }
  scope :active, where(:state => [:active, :paused, :ready, :playing])
  scope :upcoming, lambda { where("start_time > ?", DateTime.now) }
  scope :scheduled_or_active, where(:state => [:scheduled, :active])
  scope :finished, where(:state => :completed)
  scope :asc, order("start_time ASC")
  scope :desc, order("start_time DESC")

  before_create :generate_create_feed_item
  before_update :generate_update_feed_item

  Periods = %w(1 2 3 OT OT2 OT3)

  LiveStates = %w(ready active playing paused finished)

  def start
    batch_broadcasts do
      clock.start
      super
    end
  end

  def pause
    batch_broadcasts do
      clock.pause if clock.running?
      super
    end
  end

  def pause_with_elapsed_time(et)
    clock.pause if clock.running?
    clock.elapsed_time = et if et
    pause
  end

  def stop
    batch_broadcasts do
      clock.pause
      if super
        if game_over?
          finish
        else
          true
        end
      end
    end
  end

  def finish
    batch_broadcasts do
      clock.pause if super && clock.running?
      true
    end
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
    completed? ? 'F' : period ? Periods[period] : '-'
  end

  def reset_game_clock
    clock.duration = period_durations[period]
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

  def period_durations
    val = super
    val ? JSON.parse(val) : [15 * 60] * Periods.length
  end

  def period_durations=(arr)
    super(arr.to_json)
  end

  def period_minutes
    period_durations.map { |s| s / 60 }
  end

  def period_minutes=(arr)
    self.period_durations = arr.map {|m| m.to_i * 60 }
    arr
  end

  def current_period_duration
    period_durations[period]
  end

  def current_period_duration=(seconds)
    seconds = seconds.to_i
    lengths = period_durations
    lengths[period] = seconds
    self.period_durations = lengths
    clock.update_attributes(duration: seconds)
    broadcast_changes
  end

  def possible_officials
    league.officials
  end

  def ready_to_activate?
    officials_checked_in? &&
      home_team_players_checked_in? &&
      home_team_staff_checked_in? &&
      visiting_team_players_checked_in? &&
      visiting_team_staff_checked_in?
  end

  MinPlayers = 6
  MinStaff = 1

  def officials_checked_in?
    game_officials.any?
  end

  def home_team_players_checked_in?
    players.where(:team_id => home_team_id).count >= MinPlayers
  end

  def home_team_staff_checked_in?
    staff_members.where(:team_id => home_team_id).count >= MinStaff
  end

  def visiting_team_players_checked_in?
    players.where(:team_id => visiting_team_id).count >= MinPlayers
  end

  def visiting_team_staff_checked_in?
    staff_members.where(:team_id => visiting_team_id).count >= MinStaff
  end

  def current_goalie_id_for(team)
    game_goalies.current.for_team(team).select(:goalie_id).first.try(:[], "goalie_id")
  end

  def sync
    [clock, penalties.running.map(&:timer)].flatten.each do |timer|
      timer.check_expiration
    end
    true
  end

  def reset
    update_attribute(:state, :scheduled)
    update_attribute(:period, nil)
    clock.destroy if clock
  end

  def batch_broadcasts
    @batch_depth = (@batch_depth || 0) + 1
    #puts "#{object_id}: ************* Entering batch depth = #{@batch_depth}"
    @batch_options ||= {}
    ret = yield
    @batch_depth = @batch_depth - 1
    #puts "#{object_id}: ************* Exiting batch depth = #{@batch_depth}"
    broadcast_changes(@batch_options) unless batching_broadcasts?
    ret
  end

  def broadcast_changes(options={})
    unless batching_broadcasts?
      #puts "#{object_id}: ************* Performing broadcast with #{options}"
      json = active_model_serializer.new(self, options).as_json
      broadcast("/games/#{id}", json)
    else
      @batch_options = deep_safe_merge(@batch_options, options)
      #puts "#{object_id}: ************* Batching broadcast, now #{@batch_options}"
    end
  end

  def self.for_user(user)
    where("start_time between ? and ?", 1.week.ago, 1.week.from_now).
      order("games.start_time asc").
      limit(20);
  end

  private

  def first_period?
    period == 0
  end

  def set_started_at
    update_attribute(:started_at, Time.now) unless started_at
  end

  def set_ended_at
    update_attribute(:ended_at, Time.now) unless ended_at
  end

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
    activity_feed_items.create!(:message => "The game between @#{home_team.name} and @#{visiting_team.name} has started.") unless started_at
  end

  def generate_game_over_feed_item
    activity_feed_items.create!(:message => "The game between @#{home_team.name} and @#{visiting_team.name} ended.")
  end

  def set_next_period
    update_attribute(:period, period ? period + 1 : 0);
  end

  def create_clock
    self.clock = Timer.new(:owner => self, :duration => period_durations.first) unless clock
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

  def deep_safe_merge(source_hash, new_hash)
    source_hash.merge(new_hash) do |key, old, new|
      if new.respond_to?(:blank) && new.blank?
        old
      elsif (old.kind_of?(Hash) && new.kind_of?(Hash))
        deep_merge(old, new)
      elsif (old.kind_of?(Array) && new.kind_of?(Array))
        old.concat(new).uniq
      else
        new
      end
    end
  end

  def batching_broadcasts?
    @batch_depth && @batch_depth > 0
  end

  def start_eligible_penalties
    Penalty.start_eligible_penalties(self)
  end

  def pause_running_penalties
    Penalty.pause_running_penalties(self)
  end

  def terminate_penalties
    Penalty.terminate_penalties(self)
  end

  def finish_goalies
    game_goalies.current.each do |game_goalie|
      game_goalie.finish!
    end
  end
end
