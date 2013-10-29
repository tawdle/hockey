class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :system_name

  validates_presence_of :user
  validates_presence_of :system_name
  validates_uniqueness_of :system_name_id, :scope => :user_id
  validate :user_is_not_target

  attr_accessible :user, :target, :user_id, :system_name, :system_name_id

  def self.lookup(user, target_obj)
    return nil unless user && target_obj && target_obj.try(:system_name).try(:id)
    find_by_system_name_id_and_user_id(target_obj.system_name.id, user.id)
  end

  def target
    system_name.try(:nameable)
  end

  def target=(obj)
    self.system_name = obj.system_name if obj.respond_to?(:system_name)
  end

  private

  def user_is_not_target
    errors.add(:target, "may not folow self") if user && target && user == target
  end
end
