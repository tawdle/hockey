class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :followable, :polymorphic => true

  validates_presence_of :user
  validates_presence_of :followable
  validates_uniqueness_of :followable_id, :scope => [:user_id, :followable_type]
  validate :user_is_not_followable

  attr_accessible :user, :user_id, :followable, :followable_id, :followable_type

  after_create :create_feed_item

  def self.lookup(user, followable)
    return nil unless user && followable
    find_by_followable_id_and_followable_type_and_user_id(followable.id, followable.class.name, user.id)
  end

  def self.followables_for(user)
    where(:user_id => user).map(&:followable)
  end

  def self.popular
    group(:followable_type, :followable_id).select("followable_type, followable_id, count(*) as follows").order("follows desc").limit(20)
  end

  private

  def user_is_not_followable
    errors.add(:followable, "may not folow self") if user && followable && user == followable
  end

  def create_feed_item
    Feed::NewFollowing.create!(:user => user, :target => followable)
  end
end
