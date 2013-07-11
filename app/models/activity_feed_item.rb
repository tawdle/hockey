class ActivityFeedItem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :target, :polymorphic => true

  attr_accessible :target, :message

  validates_presence_of :target
  validates_presence_of :message

  def avatar_url(version_name = nil)
    creator ?
      creator.avatar_url(version_name) :
      ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end
end
