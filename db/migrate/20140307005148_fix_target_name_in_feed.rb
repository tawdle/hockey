class FixTargetNameInFeed < ActiveRecord::Migration
  def up
    ActivityFeedItem.where("target_name is not null").each do |item|
      obj = SystemName.nameable_from_name(item.target_name)
      item.update_attribute(:target_name, obj.feed_name) if obj
    end
  end

  def down
  end
end
