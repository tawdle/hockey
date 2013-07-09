class Invitation < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  symbolize :state, :in => [:pending, :accepted, :declined]
  symbolize :predicate, :in => [:manage, :join]

  attr_accessor :username_or_email
  attr_accessible :creator, :predicate, :target, :target_id, :target_type, :email, :username_or_email

  validate :provided_username_or_email, :if => :username_or_email?
  validates_presence_of :email, :unless => :username_or_email?
  validates_presence_of :creator
  validates_presence_of :target
  validates_uniqueness_of :email, :scope => [:predicate, :target_id, :target_type]

  # XXX: Validate email addresss

  after_initialize :set_defaults
  before_create :set_code

  # XXX: Convert @username to email address if neccessary
  after_create :send_invitation

  scope :pending, where(:state => :pending)
  scope :for_user, lambda {|user| where(:email => user.email) }

  def provided_username_or_email
    username_match = /^\@(.*)$/.match(@username_or_email)
    if username_match
      username = username_match[1].strip
      user = User.find_by_name(username)
      if user
        self.email = user.email
      else
        errors.add(:username_or_email, "there is no user @#{username}")
      end
    else
      if @username_or_email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        self.email = username_or_email
      else
        errors.add(:username_or_email, "isn't a valid @username or email address")
      end
    end
  end

  def username_or_email?
    username_or_email.present?
  end

  def accept!(user=nil)
    user ||= User.find_by_email(email)
    target.send("accepted_invitation_to_#{predicate}", user) if user
    update_attribute(:state, :accepted)
  end

  def decline!
    user = User.find_by_email(email)
    target.send("declined_invitation_to_#{predicate}", user) if user
    update_attribute(:state, :declined)
  end

  private

  def set_defaults
    self.state ||= :pending
  end

  def set_code
    self.code = Digest::SHA1.hexdigest(email + Time.now.to_s)
  end

  def send_invitation
    InvitationMailer.send("#{predicate}_#{target.class.name.downcase}", self).deliver
  end
end
