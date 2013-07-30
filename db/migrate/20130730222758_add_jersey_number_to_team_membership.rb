class AddJerseyNumberToTeamMembership < ActiveRecord::Migration
  def change
    add_column :team_memberships, :jersey_number, :string
  end
end
