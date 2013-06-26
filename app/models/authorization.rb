class Authorization < ActiveRecord::Base
  GlobalRoles = [:admin]
  ScopedRoles = [:manager]

  belongs_to :user
  belongs_to :authorizable, :polymorphic => true
  symbolize :role, :in => GlobalRoles + ScopedRoles

  validates_presence_of :user
  validates_presence_of :authorizable, :if => :authorization_is_scoped
  validates_uniqueness_of :user_id, :scope => [:role, :authorizable_type, :authorizable_id]

  attr_accessible :user, :role, :authorizable

  private

  def authorization_is_scoped
    ScopedRoles.include?(role)
  end
end
