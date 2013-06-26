class League < ActiveRecord::Base
  attr_accessible :name
  has_many :teams, :dependent => :destroy

  has_many :authorizations, :as => :authorizable

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  validates_presence_of :name
  validates_uniqueness_of :name

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user)
    Authorization.create!(:user => user, :role => :manager, :authorizable => self)
  end

  def declined_invitation_to_manage(invitation)
    # Whatevs
  end
end
