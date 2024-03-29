class Invitation < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true
  belongs_to :user

  symbolize :state, :in => [:pending, :accepted, :declined]
  symbolize :predicate, :in => [:manage, :join, :claim, :mark, :follow]

  attr_accessor :username_or_email
  attr_accessible :creator, :predicate, :target, :target_id, :target_type, :email, :username_or_email, :user, :language

  Target_classes = [League, Team, Location, Tournament, Player, User]

  validate :provided_username_or_email, :if => :username_or_email?
  validates_presence_of :email, :unless => :username_or_email?
  validates_presence_of :creator
  validates_presence_of :target
  validates_uniqueness_of :email, :scope => [:predicate, :target_id, :target_type]
  validates_inclusion_of :target_type, :in => Target_classes.map(&:name)

  # XXX: Validate email addresss

  after_initialize :set_defaults
  before_create :set_code
  after_create :send_invitation

  scope :pending, where(:state => :pending)
  scope :for_user, lambda {|user| where("email = ? OR user_id = ?", user.email, user.id) }
  scope :for_target, lambda {|target| where(:target_id => target.id, :target_type => target.class.name) }

  def accept!(accepting_user)
    Invitation.transaction do
      target.send("accepted_invitation_to_#{predicate}", accepting_user, self) if target.respond_to?("accepted_invitation_to_#{predicate}")
      update_attribute(:state, :accepted)
    end
  end

  def decline!
    declining_user = user || User.find_by_email(email)
    target.send("declined_invitation_to_#{predicate}", declining_user, self) if target.respond_to?("declined_invitation_to_#{predicate}")
    update_attribute(:state, :declined)
  end

  private

  def provided_username_or_email
    username_match = /^\@(.*)$/.match(username_or_email)
    if username_match
      username = username_match[1].strip
      user = User.find_by_cached_system_name(username)
      if user
        self.email = user.email
        self.user = user
      else
        errors.add(:username_or_email, "there is no user @#{username}")
      end
    else
      if username_or_email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        self.email = username_or_email
      else
        errors.add(:username_or_email, "isn't a valid @username or email address")
      end
    end
  end

  def username_or_email?
    username_or_email.present?
  end

  def set_defaults
    self.state ||= :pending
  end

  def set_code
    self.code = RandomToken.generate
  end

  def send_invitation
    InvitationMailer.delay.invite(self)
  end
end
