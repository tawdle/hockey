class ChangeSecondsToElapsedTime < ActiveRecord::Migration
  def change
    rename_column :goals, :seconds_into_period, :elapsed_time
  end
end
