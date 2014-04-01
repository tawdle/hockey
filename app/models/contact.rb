class Contact
  extend ActiveModel::Naming
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  extend ActiveModel::Translation

  define_model_callbacks :create

  before_create :send_email

  attr_accessor :name
  attr_accessor :email
  attr_accessor :user_id
  attr_accessor :subject
  attr_accessor :message

  attr_accessor :ip
  attr_accessor :referer
  attr_accessor :useragent

  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :message
  validates_presence_of :ip
  validates_presence_of :useragent

  Subjects = [
    :bigshot_at_my_arena,
    :i_have_an_idea,
    :technical_problem,
    :other
  ]

  def create
    if valid?
      run_callbacks :create
      true
    else
      false
    end
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
    ContactMailer.incoming(self).deliver
  end
end
