class Invitation < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  symbolize :state, :in => [:pending, :accepted, :declined]
  symbolize :predicate, :in => [:manage, :join]

  attr_accessible :creator, :predicate, :target, :target_id, :target_type, :email

  validates_presence_of :creator
  validates_presence_of :email
  validates_presence_of :target
  validates_uniqueness_of :email, :scope => [:predicate, :target_id, :target_type]

  # XXX: Validate email addresss

  after_initialize :set_defaults
  before_create :set_code

  # XXX: Convert @username to email address if neccessary
  after_create :send_invitation

  def to_param
    code
  end

  def self.find(id)
    find_by_code!(id)
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
