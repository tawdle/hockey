class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.string :state
      t.datetime :started_at
      t.datetime :paused_at
      t.float :seconds_paused, :default => 0.0
      t.float :duration
    end
  end
end
