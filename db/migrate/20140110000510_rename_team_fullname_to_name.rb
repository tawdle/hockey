class RenameTeamFullnameToName < ActiveRecord::Migration
  def change
    rename_column :teams, :full_name, :name
  end
end
