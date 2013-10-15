class GameOfficial < ActiveRecord::Base
  Roles = [:referee, :linesman]

  belongs_to :game
  belongs_to :official
  symbolize :role, :in => Roles

  validates_presence_of :game
  validates_presence_of :official
  validates_uniqueness_of :game_id, :scope => :official_id
end
