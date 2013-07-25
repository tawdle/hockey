class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :creator
      t.references :game
      t.references :team
      t.references :player
      t.references :assisting_player
      t.string :period
      t.integer :minutes_into_period
      t.integer :seconds_into_period
      t.timestamps
    end
    add_index :goals, :game_id
    add_index :goals, :player_id
    add_index :goals, :assisting_player_id
  end
end
