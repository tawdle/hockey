class AddCityToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :city, :string
  end
end
