class CreateGameGoalies < ActiveRecord::Migration
  def change
    create_table :game_goalies do |t|
      t.references :game
      t.references :goalie
      t.integer :start_time
      t.integer :start_period
      t.integer :end_time
      t.integer :end_period
      t.timestamps
    end
    add_index :game_goalies, :game_id
    add_index :game_goalies, :goalie_id
  end
end
