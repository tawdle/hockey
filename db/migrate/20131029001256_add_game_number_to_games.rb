class AddGameNumberToGames < ActiveRecord::Migration
  def change
    add_column :games, :number, :string
  end
end
