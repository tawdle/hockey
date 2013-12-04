class AddPenalizableAndTeamToPenalties < ActiveRecord::Migration
  def up
    add_column :penalties, :team_id, :integer

    Penalty.update_all("team_id = (select team_id from players where players.id = penalties.player_id)")

    rename_column :penalties, :player_id, :penalizable_id
    add_column :penalties, :penalizable_type, :string

    Penalty.reset_column_information
    Penalty.update_all("penalizable_type = 'Player'")
  end

  def down
    remove_column :penalties, :penalizable_type
    rename_column :penalties, :penalizable_id, :player_id
    remove_column :penalties, :team_id
  end
end
