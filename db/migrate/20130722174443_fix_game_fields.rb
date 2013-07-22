class FixGameFields < ActiveRecord::Migration
  def change
    rename_column :games, :start, :start_time
    rename_column :games, :status, :state
    add_index :games, :state
  end
end
