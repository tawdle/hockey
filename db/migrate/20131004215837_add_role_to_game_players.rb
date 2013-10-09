class AddRoleToGamePlayers < ActiveRecord::Migration
  def change
    add_column :game_players, :role, :string
  end
end
