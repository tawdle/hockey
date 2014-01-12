class Kiosk
  include ActiveModel::Validations

  validates_length_of :password, :within => 4..32
  validates_confirmation_of :password
  validates_presence_of :cookies

  attr_accessor :cookies, :password

  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()
  end

  def save
    return false unless valid?

    self.cookies.signed[:kiosk] = {
      :value => self.password,
      :secure => !(Rails.env.test? || Rails.env.development?),
      :expires => 8.hours.from_now,
      :httponly => true
    }

    true
  end

  def destroy
    self.cookies.delete :kiosk
  end

  def to_key
    [1]
  end

  def persisted?
    false
  end

  def self.password_matches(cookies, supplied_password)
    cookies.signed[:kiosk] == supplied_password
  end

  def self.load_from_cookie(cookies)
    password = cookies.signed[:kiosk]
    password ?
      Kiosk.new(:cookies => cookies, :password => password, :password_confirmation => password) :
      Kiosk.new(:cookies => cookies)
  end
end
