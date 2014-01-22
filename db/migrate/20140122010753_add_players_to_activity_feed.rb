class AddPlayersToActivityFeed < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :player_id, :integer
    add_column :activity_feed_items, :player2_id, :integer
    add_column :activity_feed_items, :player3_id, :integer
  end
end
