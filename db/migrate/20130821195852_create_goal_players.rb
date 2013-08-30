class CreateGoalPlayers < ActiveRecord::Migration
  def up
    create_table :goal_players do |t|
      t.references :goal
      t.references :player
      t.integer :ordinal
    end
    remove_column :goals, :player_id
    remove_column :goals, :assisting_player_id
  end

  def down
    remove_table :goal_players
    add_column :goals, :player_id, :integer
    add_column :goals, :assisting_player_id, :integer
  end
end
