class Location < ActiveRecord::Base
  has_many :authorizations, :as => :authorizable

  attr_accessible :name, :address_1, :address_2, :city, :state, :zip, :country, :telephone, :email, :website

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :country

  scope :managed_by, lambda {|user| joins(:authorizations).where(:authorizations => {:user_id => user.id, :role => :manager }) }

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
        ActivityFeedItem.create!(:message => "#{user.at_name} became a manager of #{name}")
      rescue ActiveRecord::RecordInvalid => e
        # If the authorization already exists, fail silently
        raise unless e.message == "Validation failed: User has already been taken"
      end
    end
  end

  def declined_invitation_to_manage(user, invitation)
  end

  private

  def url_encoded_address(param_name)
    { param_name => [address_1, address_2, city, state, zip, country].compact.join(",") }.to_query
  end

end
