class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :followable, :polymorphic => true

  validates_presence_of :user
  validates_presence_of :followable
  validates_uniqueness_of :followable_id, :scope => [:user_id, :followable_type]
  validate :user_is_not_followable

  attr_accessible :user, :user_id, :followable, :followable_id, :followable_type

  def self.lookup(user, followable)
    return nil unless user && followable
    find_by_followable_id_and_followable_type_and_user_id(followable.id, followable.class.name, user.id)
  end

  private

  def user_is_not_followable
    errors.add(:followable, "may not folow self") if user && followable && user == followable
  end
end
