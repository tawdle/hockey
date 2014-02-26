class Location < ActiveRecord::Base
  include SoftDelete
  include Followable
  include PgSearch

  has_many :authorizations, :as => :authorizable
  has_many :games

  attr_accessible :name, :address_1, :address_2, :city, :state, :zip, :country, :telephone, :email, :website

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :country

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

  multisearchable :against => [:name, :address_1, :city, :state]

  def photo_url(size=nil)
    ActionController::Base.helpers.asset_path(["fallback/location", size].compact.join("_") + ".png")
  end

  def logo_url(size=nil)
    photo_url(size)
  end

  def map_url
    "https://www.google.com/maps/?#{url_encoded_address(:q)}"
  end

  def map_image_url
    "https://maps.googleapis.com/maps/api/staticmap?zoom=13&size=200x200&scale=2&#{url_encoded_address(:markers)}&sensor=false"
  end

  def managers
    User.joins(:authorizations).where(:authorizations => {:role => :manager, :authorizable_type => self.class, :authorizable_id => self.id})
  end

  def accepted_invitation_to_manage(user, invitation)
    Location.transaction do
      begin
        Authorization.create!(:user => user, :role => :manager, :authorizable => self)
        Feed::NewLocationManager.create!(:user => user, :location => self)
      rescue ActiveRecord::RecordInvalid => e
        # If the authorization already exists, fail silently
        raise unless e.message == "Validation failed: User has already been taken"
      end
    end
  end

  def declined_invitation_to_manage(user, invitation)
  end

  def game_for_scoreboard
    games.without_deleted.active.asc.first || games.without_deleted.scheduled.asc.first
  end

  private

  def url_encoded_address(param_name)
    { param_name => [address_1, address_2, city, state, zip, country].compact.join(",") }.to_query
  end
end
