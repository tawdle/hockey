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

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A[a-zA-Z0-9_]*\Z/, :message => 'can contain only alphanumeric characters'
  validates_length_of :name, :within => 3..20

  has_many :authorizations, :dependent => :destroy

  has_many :team_memberships, :dependent => :destroy
  has_many :teams, :through => :team_memberships

  mount_uploader :avatar, AvatarUploader

  # Add helpers for authorizations
  Authorization::GlobalRoles.each do |role|
    define_method("#{role}?") { authorizations.where(:role => role).count > 0 }
  end

  Authorization::ScopedRoles.each do |role|
    define_method("#{role}_of?") { |authorizable| authorizations.where(
      :role => role, :authorizable_type => authorizable.class.name,
      :authorizable_id => authorizable.id).count > 0 }
  end
end
