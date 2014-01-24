class AddTargetNameToActivityFeedItems < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :target_name, :string
  end
end
