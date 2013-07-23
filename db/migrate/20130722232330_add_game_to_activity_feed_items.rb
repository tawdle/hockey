class AddGameToActivityFeedItems < ActiveRecord::Migration
  def up
    add_column :activity_feed_items, :game_id, :integer
    remove_column :activity_feed_items, :target_type
  end
  def down
    add_column :activity_feed_items, :target_type, :string
    remove_column :activity_feed_items, :game_id
  end
end
