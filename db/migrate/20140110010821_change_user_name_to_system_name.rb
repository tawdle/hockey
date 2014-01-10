class ChangeUserNameToSystemName < ActiveRecord::Migration
  def change
    rename_column :users, :name, :cached_system_name
  end
end
