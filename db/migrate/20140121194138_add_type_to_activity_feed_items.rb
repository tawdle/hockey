class AddTypeToActivityFeedItems < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :type, :string
  end
end
