require 'active_support/inflector'

class Player < ActiveRecord::Base
  include SoftDelete
  include PgSearch

  Roles = [:player, :goalie, :captain, :assistant_captain]
  MaxJerseyNumberLength = 4

  belongs_to :team
  belongs_to :user
  has_many :claims, :class_name => "PlayerClaim"
  has_many :followings, :as => :followable
  has_many :followers, :through => :followings, :source => :user
  has_many :game_players
  has_many :games, :through => :game_players
  symbolize :role, :in => Roles
  attr_accessor :username_or_email, :creator, :email, :photo_cache, :kiosk_password_matches
  attr_accessible :team, :username_or_email, :creator, :jersey_number, :name, :role, :photo, :photo_cache, :user_id, :kiosk_password_matches, :email

  strip_attributes

  validates_presence_of :team
  validates_presence_of :name
  validates_length_of :jersey_number, :minimum => 1, :maximum => MaxJerseyNumberLength
  validate :provided_username_or_email, :if => :username_or_email?
  validates_uniqueness_of :user_id, :scope => :team_id, :allow_nil => true
  validates_uniqueness_of :jersey_number, :scope => [:team_id, :name]
  validate :kiosk_password

  scope :for_user, lambda {|user| where(:user_id => user.id) }

  after_save :send_invitation, :if => :user_is_invited?
  after_save :create_player_claim_feed_item, :if => :user_id_changed?

  mount_uploader :photo, PhotoUploader

  multisearchable :against => [:name, :jersey_number]

  delegate :classification, :to => :team
  delegate :division, :to => :team

  def league
    team.league
  end

  def feed_name
    "[[#{at_name} #{name}]]"
  end

  def team_feed_name
    "[[#{at_name} #{team.name} ##{jersey_number}]]"
  end

  def name_and_number
    "#{jersey_number} - #{name} "
  end

  def team_and_jersey
    "#{team.system_name.name}##{jersey_number}"
  end

  def at_name
    "@#{team_and_jersey}"
  end

  def as_json(options={})
    super(options.merge(:methods => [:at_name, :name_and_number]))
  end

  def accepted_invitation_to_claim(user, invitation)
    self.user = user
    save!
  end

  def declined_invitation_to_claim(user, invitation)
    # Whatevs
  end

  def accepted_invitation_to_follow(user, invitation)
    self.followers << user unless self.followers.include?(user)
  end

  private

  def provided_username_or_email
    username_match = /^\@(.*)$/.match(username_or_email)
    if username_match
      username = username_match[1].strip
      user = User.find_by_cached_system_name(username)
      if user
        self.email = user.email
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

  def user_is_invited?
    email.present? && user.nil?
  end

  def send_invitation
    unless Invitation.create(:creator => creator, :target => self, :predicate => :claim, :email => email)
      self.errors.add(:email, "failed to create invitation")
    end
  end

  def kiosk_password
    errors.add(:base, "Incorrect kiosk password provided") if kiosk_password_matches == false
  end

  def create_player_claim_feed_item
    Feed::NewPlayerClaim.create!(:user => user, :player => self) if user
  end
end
