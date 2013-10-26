class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :avatar_cache
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  attr_accessible :avatar, :avatar_cache

  NameFormat = "[[:alpha:]\\d\\-_]+"

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A#{NameFormat}\Z/, :message => 'can contain only alphanumeric characters'
  validates_length_of :name, :within => 3..20
  validates_uniqueness_of :nameable_id, :scope => :nameable_type, :allow_nil => true

  has_many :authorizations, :dependent => :destroy

  has_many :players, :dependent => :destroy
  has_many :teams, :through => :players

  belongs_to :nameable, :polymorphic => true

  mount_uploader :avatar, AvatarUploader

  before_update :update_mentions, :if => :name_changed?

  # Add helpers for authorizations
  Authorization::GlobalRoles.each do |role|
    define_method("#{role}?") { authorizations.where(:role => role).count > 0 }
  end

  Authorization::ScopedRoles.each do |role|
    define_method("#{role}_of?") { |authorizable| authorizable && authorizations.where(
      :role => role, :authorizable_type => authorizable.class.name,
      :authorizable_id => authorizable.id).count > 0 }
  end

  def marker_of_game?(game)
    game && (marker_of?(game.home_team.league) || marker_of?(game.visiting_team.league))
  end

  def following?(target)
    target = target.user unless target.is_a? User
    Following.where(:user_id => id, :target_id => target.id).any?
  end

  def at_name
    "@#{name}"
  end

  def merge(other)
    # Find all references to other, change them to references to us
    User.transaction do
      update_id(Authorization, :user, other)
      uodate_id(Following, :user, other)
      update_id(Following, :target, other)
      update_id(Invitation, :user, other)
      update_id(Invitation, :creator, other)
      Mention.rename(other, other.at_name, at_name)
      update_id(Mention, :user, other)
      update_id(Player, :user, other)
      update_id(ActivityFeedItem, :creator, other)
      update_id(Goal, :creator, other)
      update_id(Goal, :player, other)
      update_id(Goal, :assisting_player, other)
      other.destroy!
    end
  end

  private

  def update_id(model, field, other)
    model.update_all("#{field}_id = #{id}", "#{field}_id = #{other.id}")
  end

  def update_mentions
    Mention.rename(self, name_was, name)
  end
end
