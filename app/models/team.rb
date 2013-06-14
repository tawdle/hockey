class Team < ActiveRecord::Base
  after_create :set_manager
  belongs_to :league
  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships

  validates_presence_of :name
  validates_presence_of :league

  attr_accessor :manager
  attr_accessible :name, :league_id, :league, :manager

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  private

  def set_manager
    Authorization.create!(:role => :manager, :user => manager, :authorizable => self)
  end
end
