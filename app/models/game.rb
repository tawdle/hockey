class Game < ActiveRecord::Base
  state_machine :initial => :scheduled do
    event :start do
      transition :scheduled => :active
    end

    event :finish do
      transition :active => :finished
    end

    event :cancel do
      transition [:scheduled, :active] => :canceled
    end

    after_transition any => :canceled, :do => :generate_cancel_feed_item
    after_transition any => :active, :do => :generate_game_started_feed_item
    after_transition any => :finished, :do => :generate_game_over_feed_item

    state all - :scheduled do
      validate {|game| game.send(:schedule_not_changed) }
    end

    state any - :scheduled do
      validate {|game| game.send(:location_not_changed) }
    end

    state any - :active do
      validate {|game| game.send(:scores_are_not_changed) }
    end

    state :finished do
      validate :scores_are_set
    end
  end

  #symbolize :status, :in => [:scheduled, :active, :finished, :canceled]

  belongs_to :home_team, :class_name => 'Team'
  belongs_to :visiting_team, :class_name => 'Team'
  belongs_to :location
  has_many :activity_feed_items

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start_time
  validate :start_time_is_in_future, :if => :start_time_changed?

  attr_accessor :updater
  attr_accessible :status, :home_team, :home_team_id, :home_team_score, :visiting_team, :visiting_team_id, :visiting_team_score, :location, :location_id, :start_time, :updater
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

  def our_score(team)
    team == home_team ? home_team_score : visiting_team_score
  end

  def their_score(team)
    team == home_team ? visiting_team_score : home_team_score
  end

  def their_team(team)
    team == home_team ? visiting_team : home_team
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
    activity_feed_items.create!(:message => "The between @#{home_team.name} and @#{visiting_team} ended.")
  end

  def home_and_visiting_teams_are_different
    errors.add(:base, "Home and visiting teams must be different") if home_team == visiting_team
  end

  def scores_are_not_changed
    errors.add(:base, "Scores may only be changed while the game is in progress") if (home_team_score_changed? || visiting_team_score_changed?)
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

  def scores_are_set
    errors.add(:base, "Game may not be finished unless scores have been provided") unless (home_team_score && visiting_team_score)
  end
end
