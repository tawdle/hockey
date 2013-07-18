class Game < ActiveRecord::Base
  symbolize :status, :in => [:scheduled, :active, :finished, :canceled]

  belongs_to :home_team, :class_name => 'Team'
  belongs_to :visiting_team, :class_name => 'Team'
  belongs_to :location

  validates_presence_of :home_team
  validates_presence_of :visiting_team
  validate :home_and_visiting_teams_are_different
  validates_presence_of :location
  validates_presence_of :start
  validate :start_is_in_future, :only => :create

  attr_accessible :status, :home_team, :home_team_id, :visiting_team, :visiting_team_id, :location, :location_id, :start
  attr_readonly :home_team, :home_team_id, :visiting_team, :visiting_team_id

  after_initialize :initialize_defaults

  scope :for_team, lambda {|team| where("home_team_id = ? or visiting_team_id = ?", team.id, team.id) }
  scope :for_league, lambda {|league| joins("INNER JOIN teams h on home_team_id = h.id").joins("INNER JOIN teams v on visiting_team_id = v.id").where("h.league_id = ? or v.league_id = ?", league.id, league.id) }
  scope :upcoming, lambda { where(:status => :scheduled).where("start > ?", DateTime.now) }

  private

  def home_and_visiting_teams_are_different
    errors.add(:base, "Home and visiting teams must be different") if home_team == visiting_team
  end

  def start_is_in_future
    errors.add(:start, "must be in the future") if start && start < Time.now
  end

  def initialize_defaults
    self.status ||= :scheduled
  end
end
