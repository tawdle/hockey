class Team < ActiveRecord::Base
  after_create :set_manager
  belongs_to :league
  has_one :user, :as => :nameable # solely for team.name
  has_many :team_memberships, :dependent => :destroy
  has_many :members, :through => :team_memberships
  has_many :authorizations, :as => :authorizable
  delegate :name, :to => :user

  validates_presence_of :user
  validates_presence_of :full_name
  validates_presence_of :league

  alias_method :players, :members

  def activity_feed_items
    ActivityFeedItem.for(user)
  end

  attr_accessor :manager
  attr_accessible :full_name, :logo_cache, :logo, :manager, :user_attributes, :league

  accepts_nested_attributes_for :user

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  def at_name
    "@#{name}"
  end

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user)
    Team.transaction do
      Authorization.create!(:user => user, :role => :manager, :authorizable => self)
      ActivityFeedItem.create!(:creator => self.user, :message => "@#{user.name} became a manager of #{name}")
    end
  end

  def declined_invitation_to_manage(user)
    # Whatevs
  end

  def accepted_invitation_to_join(user)
    ActivityFeedItem.create!(:message => "#{user.at_name} joined #{at_name}")
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
