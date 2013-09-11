class FixTimeInGoals < ActiveRecord::Migration
  def up
    remove_column :goals, :period
    add_column :goals, :period, :integer, :null => false, :default => 0
    remove_column :goals, :minutes_into_period
  end

  def down
    add_column :goals, :minutes_into_period, :integer
    change_column :goals, :period, :string
  end
end
