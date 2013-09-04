class CreateGamePlayers < ActiveRecord::Migration
  def change
    create_table :game_players do |t|
      t.references :game
      t.references :player
    end
    add_index :game_players, :game_id
    add_index :game_players, :player_id
    add_index :game_players, [:game_id, :player_id], :unique => true
  end
end
