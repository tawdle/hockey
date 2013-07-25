class RemoveScoresFromGames < ActiveRecord::Migration
  def up
    remove_column :games, :home_team_score
    remove_column :games, :visiting_team_score
  end

  def down
    add_column :games, :home_team_score, :integer
    add_colimn :games, :visiting_team_score, :integer
  end
end
