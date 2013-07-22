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
  validate :schedule_not_changed_after_game_starts
  validate :location_not_changed_after_game_starts
  validate :start_time_is_in_future, :if => :start_time_changed?
  validate :scores_not_set_until_game_starts

  attr_accessible :status, :home_team, :home_team_id, :home_team_score, :visiting_team, :visiting_team_id, :visiting_team_score, :location, :location_id, :start_time, :complete
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :for_league, lambda {|league| joins("INNER JOIN teams h on home_team_id = h.id").joins("INNER JOIN teams v on visiting_team_id = v.id").where("h.league_id = ? or v.league_id = ?", league.id, league.id) }
  scope :upcoming, lambda { where(:status => :scheduled).where("start_time > ?", DateTime.now) }

  private

  def home_and_visiting_teams_are_different
    errors.add(:base, "Home and visiting teams must be different") if home_team == visiting_team
  end

  def scores_not_set_until_game_starts
    errors.add(:base, "Scores may not be set until the game starts") if scheduled? && (home_team_score || visiting_team_score)
  end

  def start_time_is_in_future
    errors.add(:start_time, "must be in the future") if start_time && start_time < Time.now
  end

  def schedule_not_changed_after_game_starts
    errors.add(:start_time, "can't be changed after game starts") if persisted? && start_time_changed? && !scheduled?
  end

  def location_not_changed_after_game_starts
    errors.add(:location, "can't be changed after game starts") if persisted? && location_id_changed? && !scheduled?
  end
end
