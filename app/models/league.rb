class League < ActiveRecord::Base
  Divisions = %w(prenovice initiation novice atom pee_wee bantam midget intermediate juvenile secondary junior major_junior other_junior adult_recreational senior college university house).map(&:to_sym)
  Classifications = %w(a b c aa bb cc aaa).map(&:to_sym)

  has_many :teams, :dependent => :destroy
  has_many :authorizations, :as => :authorizable
  has_many :league_officials
  has_many :officials, :through => :league_officials
  attr_accessible :name, :logo, :logo_cache, :division, :classification
  symbolize :classification, :in => Classifications, :allow_nil => true
  symbolize :division, :in => Divisions

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :logo, LogoUploader

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def markers
    User.joins(:authorizations).where(:authorizations => {:role => :marker, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    League.transaction do
      begin
        Authorization.create!(:user => user, :role => :manager, :authorizable => self)
        ActivityFeedItem.create!(:message => "#{user.at_name} became a manager of #{name}")
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
        ActivityFeedItem.create!(:message => "#{user.at_name} became a marker of #{name}")
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
