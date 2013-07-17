class CreateMentions < ActiveRecord::Migration
  def up
    create_table :mentions do |t|
      t.references :activity_feed_item
      t.references :user
      t.timestamps
    end
    remove_column :activity_feed_items, :target_id
    add_index :mentions, :activity_feed_item_id
    add_index :mentions, :user_id
  end

  def down
    drop_table :mentions
    add_column :activity_feed_items, :target_id, :integer
  end
end
