class Team < ActiveRecord::Base
  after_create :set_manager
  belongs_to :league
  has_one :user, :as => :nameable # solely for team.name
  has_many :players, :dependent => :destroy, :order => "lpad(jersey_number, #{Player::MaxJerseyNumberLength}, '0'), name"
  has_many :users, :through => :players
  has_many :authorizations, :as => :authorizable
  has_many :staff_members, :inverse_of => :team
  delegate :name, :to => :user

  validates_presence_of :user
  validates_presence_of :full_name
  validates_presence_of :league

  def activity_feed_items
    ActivityFeedItem.for(user)
  end

  attr_accessor :manager
  attr_accessible :full_name, :logo_cache, :logo, :manager, :user_attributes, :league

  accepts_nested_attributes_for :user

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  def self.find_by_name(name)
    user = User.find_by_name(name)
    user && user.nameable_type == "Team" && user.nameable
  end

  def at_name
    "@#{name}"
  end

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    Team.transaction do
      begin
        Authorization.create!(:user => user, :role => :manager, :authorizable => self)
        ActivityFeedItem.create!(:message => "@#{user.name} became a manager of #{at_name}")
      rescue ActiveRecord::RecordInvalid => e
        # If the authorization already exists, fail silently
        raise unless e.message == "Validation failed: User has already been taken"
      end
    end
  end

  def declined_invitation_to_manage(user, invitation)
    # Whatevs
  end

  mount_uploader :logo, LogoUploader

  private

  def set_manager
    Authorization.create!(:role => :manager, :user => manager, :authorizable => self)
  end
end
