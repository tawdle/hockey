class ActivityFeedItem < ActiveRecord::Base
  belongs_to :target, :polymorphic => true

  attr_accessible :target, :message

  validates_presence_of :target
  validates_presence_of :message
end
