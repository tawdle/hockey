class FixActivityFeedItemCreatorId < ActiveRecord::Migration
  def change
    rename_column :activity_feed_items, :creator, :creator_id
  end
end
