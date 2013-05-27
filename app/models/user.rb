class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A[a-zA-Z0-9_]*\Z/, :message => 'can contain only alphanumeric characters'
  validates_length_of :name, :within => 3..20
end
