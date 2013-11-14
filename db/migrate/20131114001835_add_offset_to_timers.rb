class AddOffsetToTimers < ActiveRecord::Migration
  def change
    add_column :timers, :offset, :float, :default => 0
  end
end
