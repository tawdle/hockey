class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :class_name => "User"

  validates_presence_of :user
  validates_presence_of :target
  validates_uniqueness_of :target_id, :scope => :target_id
  validate :user_is_not_target

  attr_accessible :user, :target, :user_id, :target_id

  def self.lookup(user, target)
    return nil unless user
    target = target.user unless target.is_a? User
    find_by_target_id_and_user_id(target.id, user.id)
  end

  def target=(val)
    val = val.user unless val.nil? || val.is_a?(User)
    super(val)
  end

  private

  def user_is_not_target
    errors.add(:target, "may not folow self") if user == target
  end
end
