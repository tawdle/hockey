class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :avatar_cache
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :avatar, :avatar_cache, :time_zone, :language, :system_name_attributes
  attr_readonly :name

  symbolize :language, in: [:en, :fr], allow_nil: true

  has_many :authorizations, :dependent => :destroy
  has_many :players, :dependent => :destroy, :conditions => { deleted_at: nil }
  has_many :teams, :through => :players
  has_one :system_name, :as => :nameable, :inverse_of => :nameable

  mount_uploader :avatar, AvatarUploader

  after_initialize :init_system_name
  before_update :update_mentions, :if => :name_changed?
  before_create :cache_name

  accepts_nested_attributes_for :system_name

  # Add helpers for authorizations
  Authorization::GlobalRoles.each do |role|
    define_method("#{role}?") { authorizations.where(:role => role).count > 0 }
  end

  Authorization::ScopedRoles.each do |role|
    define_method("#{role}_of?") { |authorizable| authorizable && authorizations.where(
      :role => role, :authorizable_type => authorizable.class.base_class.name,
      :authorizable_id => authorizable.id).count > 0 }
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

  def init_system_name
    self.system_name ||= SystemName.new if new_record?
  end

  def update_id(model, field, other)
    model.update_all("#{field}_id = #{id}", "#{field}_id = #{other.id}")
  end

  def update_mentions
    Mention.rename(self, name_was, name)
  end

  def cache_name
    self.name = system_name.name
  end
end
