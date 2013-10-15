class Official < ActiveRecord::Base
  has_many :league_officials
  has_many :leagues, :through => :league_officials
  has_many :game_officials
  has_many :games, :through => :game_officials

  validates_presence_of :name
  validates_presence_of :leagues

  attr_accessible :name
end
