class RenameTeamUsersToTeamMembers < ActiveRecord::Migration
  def change
    rename_column :team_users, :user_id, :member_id
    rename_table :team_users, :team_members
  end
end
