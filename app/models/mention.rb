class Mention < ActiveRecord::Base
  belongs_to :activity_feed_item, :inverse_of => :mentions
  belongs_to :mentionable, :polymorphic => true

  attr_accessible :activity_feed_item, :mentionable_id, :mentionable_type, :mentionable

  validates_presence_of :activity_feed_item
  validates_presence_of :mentionable

  NameOrPlayerPattern = /\@(#{SystemName::NameFormat}(?:#[\d]+)?)/
  FeedNamePattern = /\[\[#{NameOrPlayerPattern} ([^\]]+)\]\]/

  def self.rename(user, old_name, new_name)
    ActivityFeedItem.joins(:mentions).where(:mentions => {:user_id => user.id}).readonly(false).each do |item|
      item.message = item.message.gsub("@#{old_name}", "@#{new_name}")
      item.save!
    end
  end
end
