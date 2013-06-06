class RenameTeamMemberToTeamMembership < ActiveRecord::Migration
  def change
    rename_table :team_members, :team_memberships
  end
end
