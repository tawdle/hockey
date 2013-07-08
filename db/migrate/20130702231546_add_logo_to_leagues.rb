class AddLogoToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :logo, :string
  end
end
