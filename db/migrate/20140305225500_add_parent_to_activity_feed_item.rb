class AddParentToActivityFeedItem < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :parent_id, :integer
    add_index :activity_feed_items, :parent_id
  end
end
