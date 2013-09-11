class AddPeriodToGame < ActiveRecord::Migration
  def change
    add_column :games, :period, :integer
    add_column :games, :period_duration, :integer, :null => false, :default => 15 * 60
  end
end
