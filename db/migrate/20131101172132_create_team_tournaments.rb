class CreateTeamTournaments < ActiveRecord::Migration
  def change
    create_table :teams_tournaments do |t|
      t.references :team, :null => false
      t.references :tournament, :null => false
    end

    add_index :teams_tournaments, :team_id
    add_index :teams_tournaments, :tournament_id
    add_index :teams_tournaments, [:team_id, :tournament_id], :unique => true
  end
end
