class Location < ActiveRecord::Base
  attr_accessible :name, :address_1, :address_2, :city, :state, :zip, :country, :telephone, :email, :website

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :country

  def map_url
    "https://www.google.com/maps/?#{url_encoded_address(:q)}"
  end

  def map_image_url
    "https://maps.googleapis.com/maps/api/staticmap?zoom=13&size=200x200&scale=2&#{url_encoded_address(:markers)}&sensor=false"
  end

  private

  def url_encoded_address(param_name)
    { param_name => [address_1, address_2, city, state, zip, country].compact.join(",") }.to_query
  end

end
