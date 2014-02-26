module Followable
  extend ActiveSupport::Concern

  included do
    has_one :system_name, :as => :nameable
    attr_accessible :system_name_attributes
    accepts_nested_attributes_for :system_name
    validates_presence_of :system_name
    after_initialize :set_nameable
    has_many :followings, :as => :followable
    has_many :followers, :through => :followings, :source => :user
  end

  def at_name
    "@#{system_name.name}"
  end

  def accepted_invitation_to_follow(user, invitation)
    self.followers << user unless self.followers.include?(user)
  end

  private

  def set_nameable
    # Not sure why ActiveRecord doesn't do this for us
    system_name || build_system_name
    system_name.nameable = self
  end
end

