class ActivityFeedItem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  attr_accessible :creator, :target, :message

  #validates_presence_of :target
  validates_presence_of :message

  default_scope order("created_at desc")

  def self.for(user)
    where("creator_id = ? or creator_id in (select target_id from followings where user_id = ?)", user.id, user.id)
  end

  def avatar_url(version_name = nil)
    creator ?
      creator.avatar_url(version_name) :
      ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end
end
