class Invitation < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  symbolize :state, :in => [:pending, :accepted, :declined]
  symbolize :action, :in => [:manage, :join]
  validates_presence_of :email
  validates_presence_of :target
  validates_uniqueness_of :email, :scope => [:action, :target_id, :target_type]

  # XXX: Validate email addresss

  after_initialize :set_defaults
  before_create :set_code

  # XXX: Convert @username to email address if neccessary
  after_create :send_invitation

  def accept!
    user = User.find_by_email(email)
    target.send("accepted_invitation_to_#{action}", user) if user
    update_attribute(:state, :accepted)
  end

  def decline!
    user = User.find_by_email(email)
    target.send("declined_invitation_to_#{action}", user) if user
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
    Invitations.send("#{action}_#{target.class.name.downcase}", self)
  end
end
