class Team < ActiveRecord::Base
  after_create :set_manager
  belongs_to :league
  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships
  has_many :authorizations, :as => :authorizable
  has_many :activity_feed_items, :as => :target

  validates_presence_of :name
  validates_presence_of :league

  attr_accessor :manager
  attr_accessible :name, :logo_cache, :logo, :manager

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user)
    Team.transaction do
      Authorization.create!(:user => user, :role => :manager, :authorizable => self)
      ActivityFeedItem.create!(:target => self, :message => "@#{user.name} became a manager of #{name}")
    end
  end

  def declined_invitation_to_manage(user)
    # Whatevs
  end

  def accepted_invitation_to_join(user)
    Team.transaction do
      TeamMembership.create!(:member => user, :team => self)
      ActivityFeedItem.create!(:target => self, :message => "@#{user.name} joined #{name}")
    end
  end

  def declined_invitation_to_join(user)
    # Whatevs
  end

  mount_uploader :logo, LogoUploader

  private

  def set_manager
    Authorization.create!(:role => :manager, :user => manager, :authorizable => self)
  end
end
