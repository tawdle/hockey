class RenameTeamMembershipsToPlayers < ActiveRecord::Migration
  def change
    rename_table :team_memberships, :players
  end
end
