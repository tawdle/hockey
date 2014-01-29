class AddAlphaLogoToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :alpha_logo, :string
    Team.update_all("alpha_logo = logo")
  end

  def down
    remove_column :teams, :alpha_logo, :string
  end
end
