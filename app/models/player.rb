require 'active_support/inflector'

class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  attr_accessor :username_or_email, :creator
  attr_accessible :team, :username_or_email, :creator, :jersey_number

  validates_presence_of :team
  validates_presence_of :jersey_number
  validate :provided_username_or_email, :if => :username_or_email?
  validates_uniqueness_of :user_id, :scope => :team_id, :allow_nil => true
  validates_uniqueness_of :jersey_number, :scope => :team_id

  scope :for_user, lambda {|user| where(:user_id => user.id) }

  after_save :send_invitation, :if => :user_is_invited?

  def at_name
    user.try(:at_name) || "@#{team.name}##{jersey_number}"
  end

  def as_json(options={})
    super(options.merge(:methods => [:at_name]))
  end

  private

  def accepted_invitation_to_claim(user, invitation)
    self.user = user
    save!
  end

  def declined_invitation_to_claim(user, invitation)
    # Whatevs
  end

  def provided_username_or_email
    username_match = /^\@(.*)$/.match(username_or_email)
    if username_match
      username = username_match[1].strip
      user = User.find_by_name(username)
      if user
        self.user = user
      else
        errors.add(:username_or_email, "there is no user @#{username}")
      end
    else
      if username_or_email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        self.user = User.find_by_email(username_or_email)
      else
        errors.add(:username_or_email, "isn't a valid @username or email address")
      end
    end
  end

  def username_or_email?
    username_or_email.present?
  end

  def user_is_invited?
    !user && username_or_email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def send_invitation
    Invitation.create!(:creator => creator, :target => self, :predicate => :claim, :email => username_or_email)
  end
end
