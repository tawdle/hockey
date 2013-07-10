class CreateActivityFeedItems < ActiveRecord::Migration
  def change
    create_table :activity_feed_items do |t|
      t.references :target, :polymorphic => true
      t.string :message
      t.timestamps
    end
  end
end
