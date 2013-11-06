class Official < ActiveRecord::Base
  include SoftDelete

  belongs_to :league
  has_many :game_officials
  has_many :games, :through => :game_officials

  validates_presence_of :name
  validates_presence_of :league

  validates_uniqueness_of :name, :scope => :league_id

  attr_accessible :name
end
