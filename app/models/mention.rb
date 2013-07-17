class Mention < ActiveRecord::Base
  belongs_to :activity_feed_item
  belongs_to :user

  attr_accessible :activity_feed_item, :user

  validates_presence_of :activity_feed_item
  validates_presence_of :user
end
