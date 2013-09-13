class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.string :state
      t.references :game
      t.references :player
      t.references :serving_player
      t.references :timer
      t.integer :period
      t.float :elapsed_time
      t.string :category
      t.string :infraction
      t.integer :minutes
      t.timestamps
    end
    add_index :penalties, :game_id
    add_index :penalties, :player_id
  end
end
