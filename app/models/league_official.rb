class LeagueOfficial < ActiveRecord::Base
  belongs_to :league
  belongs_to :official

  validates_presence_of :league
  validates_presence_of :official
  validates_uniqueness_of :official_id, :scope => :league_id
end
