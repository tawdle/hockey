require 'active_support/inflector'

class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  attr_accessor :username_or_email, :creator
  attr_accessible :team, :username_or_email, :creator, :jersey_number

  validates_presence_of :team
  validate :provided_username_or_email, :if => :username_or_email?
  validates_uniqueness_of :user_id, :scope => :team_id
  validates_uniqueness_of :jersey_number, :scope => :team_id

  scope :for_user, lambda {|user| where(:user_id => user.id) }

  before_save :send_invitation, :if => :user_was_fabricated?, :prepend => true

  def at_name
    user.try(:at_name) || "@#{team.name}##{jersey_number}"
  end

  private

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
        self.user = User.find_by_email(username_or_email) || fabricate_user
      else
        errors.add(:username_or_email, "isn't a valid @username or email address")
      end
    end
  end

  def username_or_email?
    username_or_email.present?
  end

  def fabricate_user
    name = ActiveSupport::Inflector.transliterate(username_or_email.split("@")[0], "") + (rand * 1000).to_i.to_s
    User.new(:name => name, :email => username_or_email, :password => Digest::SHA1.hexdigest(Time.now.to_s))
  end

  def user_was_fabricated?
    user && user.new_record?
  end

  def send_invitation
    Invitation.create!(:creator => creator, :user => user, :target => team, :predicate => :join, :email => user.email)
  end
end
