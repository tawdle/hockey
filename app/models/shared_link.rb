class SharedLink
  extend ActiveModel::Naming
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  extend ActiveModel::Translation

  define_model_callbacks :create

  before_create :send_email

  attr_accessor :email
  attr_accessor :user_id
  attr_accessor :message
  attr_accessor :link_id

  validates_format_of :email, :with => /.+@.+\..+/i
  validates_presence_of :user
  validates_presence_of :link

  def create
    if valid?
      run_callbacks :create
      true
    else
      false
    end
  end

  def user
    User.find_by_id(user_id) if user_id
  end

  def link
    ActivityFeedItem.find_by_id(link_id) if link_id.present?
  end

  def save
    create
  end

  def to_key
    nil
  end

  def persisted?
    false
  end

  def initialize(attrs={})
    attrs.each do |key, val|
      send "#{key}=", val
    end
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  private

  def send_email
    SharedLinkMailer.share(self).deliver
  end
end

