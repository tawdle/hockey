class AddMvpsToGames < ActiveRecord::Migration
  def change
    add_column :games, :home_team_mvp_id, :integer
    add_column :games, :visiting_team_mvp_id, :integer
  end
end
