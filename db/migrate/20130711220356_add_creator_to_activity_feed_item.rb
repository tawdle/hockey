class AddCreatorToActivityFeedItem < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :creator, :integer
  end
end
