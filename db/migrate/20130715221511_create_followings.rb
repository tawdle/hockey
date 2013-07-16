class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :user
      t.references :target
      t.timestamps
    end
    add_index :followings, :user_id
    add_index :followings, :target_id
    add_index :followings, [:user_id, :target_id], :unique => true
  end
end
