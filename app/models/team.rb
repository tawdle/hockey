class Team < ActiveRecord::Base
  after_create :set_manager
  belongs_to :league
  has_one :system_name, :as => :nameable
  has_many :players, :dependent => :destroy, :order => "lpad(jersey_number, #{Player::MaxJerseyNumberLength}, '0'), name"
  has_many :users, :through => :players
  has_many :authorizations, :as => :authorizable
  has_many :staff_members, :inverse_of => :team
  delegate :name, :to => :system_name

  validates_presence_of :full_name
  validates_presence_of :system_name
  validates_presence_of :league

  def activity_feed_items
    ActivityFeedItem.for(self)
  end

  attr_accessor :manager
  attr_accessible :full_name, :logo_cache, :logo, :manager, :league, :system_name_attributes

  accepts_nested_attributes_for :system_name

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  before_validation :set_nameable

  def self.find_by_name(name)
    SystemName.find_by_name_and_nameable_type(name, "Team").try(:nameable)
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
        ActivityFeedItem.create!(:message => "#{user.at_name} became a manager of #{at_name}")
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

  def set_nameable
    # Not sure why ActiveRecord doesn't do this for us
    system_name || build_system_name
    system_name.nameable = self
  end
end
