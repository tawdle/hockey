class League < ActiveRecord::Base
  include SoftDelete
  include Followable
  include PgSearch

  Divisions = %w(prenovice initiation novice atom pee_wee bantam midget intermediate juvenile secondary junior major_junior other_junior adult_recreational senior college university house).map(&:to_sym)
  Classifications = %w(a b c aa bb cc aaa).map(&:to_sym)

  has_many :games, :dependent => :destroy, :conditions => { deleted_at: nil }
  has_many :teams, :dependent => :destroy, :conditions => { deleted_at: nil }
  has_many :officials, :conditions => { deleted_at: nil }
  has_many :authorizations, :as => :authorizable, :dependent => :destroy
  has_many :mentions, :as => :mentionable
  has_many :activity_feed_items, :through => :mentions
  attr_accessible :name, :logo, :logo_cache, :division, :classification
  symbolize :classification, :in => Classifications, :allow_nil => true
  symbolize :division, :in => Divisions

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:classification, :division]

  mount_uploader :logo, LogoUploader

  strip_attributes

  multisearchable :against => [:name, :classification, :division]

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class.base_class, :authorizable_id => self.id})
  end

  def markers
    User.joins(:authorizations).where(:authorizations => {:role => :marker, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    League.transaction do
      begin
        Authorization.create!(:user => user, :role => :manager, :authorizable => self)
        Feed::NewLeagueManager.create!(:user => user, :league => self)
      rescue ActiveRecord::RecordInvalid => e
        # If the authorization already exists, fail silently
        raise unless e.message == "Validation failed: User has already been taken"
      end
    end
  end

  def declined_invitation_to_manage(user, invitation)
    # Whatevs
  end

  def accepted_invitation_to_mark(user, invitation)
    League.transaction do
      begin
        Authorization.create!(:user => user, :role => :marker, :authorizable => self)
        Feed::NewLeagueMarker.create!(:user => user, :league => self)
      rescue ActiveRecord::RecordInvalid => e
        # If the authorization already exists, fail silently
        raise unless e.message == "Validation failed: User has already been taken"
      end
    end
  end

  def declined_invitation_to_manage(user, invitation)
    # Whatevs
  end
end
