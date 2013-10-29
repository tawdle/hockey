class Mention < ActiveRecord::Base
  belongs_to :activity_feed_item
  belongs_to :system_name

  attr_accessible :activity_feed_item, :system_name

  validates_presence_of :activity_feed_item
  validates_presence_of :system_name

  def self.rename(user, old_name, new_name)
    ActivityFeedItem.joins(:mentions).where(:mentions => {:user_id => user.id}).readonly(false).each do |item|
      item.message = item.message.gsub("@#{old_name}", "@#{new_name}")
      item.save!
    end
  end
end
