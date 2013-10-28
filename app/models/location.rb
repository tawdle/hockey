class Location < ActiveRecord::Base
  attr_accessible :name, :address_1, :address_2, :city, :state, :zip, :country, :telephone, :email, :website

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :country
end
