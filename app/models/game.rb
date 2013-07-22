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

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start_time
  validate :start_time_is_in_future, :if => :start_time_changed?

  attr_accessible :status, :home_team, :home_team_id, :home_team_score, :visiting_team, :visiting_team_id, :visiting_team_score, :location, :location_id, :start_time
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :for_league, lambda {|league| joins("INNER JOIN teams h on home_team_id = h.id").joins("INNER JOIN teams v on visiting_team_id = v.id").where("h.league_id = ? or v.league_id = ?", league.id, league.id) }
  scope :scheduled, where(:state => :scheduled)
  scope :due, lambda { where("start_time < ?", DateTime.now) }
  scope :upcoming, lambda { where("start_time > ?", DateTime.now) }

  private

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
