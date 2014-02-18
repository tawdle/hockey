class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :goal_id
      t.integer :feed_item_id
      t.string :file_key
      t.string :thumb_key
      t.timestamps
    end
    add_index :videos, :goal_id
    add_index :videos, :feed_item_id
  end
end
