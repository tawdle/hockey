class FixTeamMembershipIndex < ActiveRecord::Migration
  def up
    execute("drop index index_team_users_on_team_id_and_user_id")
    add_index :team_memberships, [:member_id, :team_id], :uniq => true
    rename_index :team_memberships, :index_team_users_on_team_id, :index_team_memberships_on_team_id
    rename_index :team_memberships, :index_team_users_on_user_id, :index_team_memberships_on_member_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
