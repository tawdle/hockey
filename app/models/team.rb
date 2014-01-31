class Team < ActiveRecord::Base
  include SoftDelete
  include Followable

  after_create :set_manager
  belongs_to :league
  has_many :players, :dependent => :destroy, :order => "lpad(jersey_number, #{Player::MaxJerseyNumberLength}, '0'), name", :conditions => { deleted_at: nil }
  has_many :users, :through => :players
  has_many :authorizations, :as => :authorizable, :dependent => :destroy
  has_many :staff_members, :inverse_of => :team, :conditions => { deleted_at: nil }

  validates_presence_of :name
  validates_presence_of :league

  def activity_feed_items
    ActivityFeedItem.for(self)
  end

  attr_accessor :manager
  attr_accessible :name, :logo_cache, :logo, :alpha_logo_cache, :alpha_logo, :manager, :league, :city

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  def self.find_by_at_name(name)
    SystemName.find_by_name_and_nameable_type(name, "Team").try(:nameable)
  end

  def full_name
    [name, city].compact.join(" - ")
  end

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    Team.transaction do
      begin
        Authorization.create!(:user => user, :role => :manager, :authorizable => self)
        Feed::NewTeamManager.create!(:user => user, :team => self)
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
  mount_uploader :alpha_logo, AlphaLogoUploader

  private

  def set_manager
    Authorization.create!(:role => :manager, :user => manager, :authorizable => self)
  end
end
