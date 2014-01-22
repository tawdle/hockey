class AddUserAndObjectToActivityFeed < ActiveRecord::Migration
  def change
    add_column :activity_feed_items, :subject_id, :integer
    add_column :activity_feed_items, :target_id, :integer
  end
end
