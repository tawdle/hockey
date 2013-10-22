class League < ActiveRecord::Base
  has_many :teams, :dependent => :destroy
  has_many :authorizations, :as => :authorizable
  has_many :league_officials
  has_many :officials, :through => :league_officials
  attr_accessible :name, :logo, :logo_cache

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :logo, LogoUploader

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def recorders
    User.joins(:authorizations).where(:authorizations => {:role => :recorder, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    Authorization.create!(:user => user, :role => :manager, :authorizable => self)
  end

  def declined_invitation_to_manage(user, invitation=nil)
    # Whatevs
  end
end
