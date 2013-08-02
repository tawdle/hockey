class AddClockIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :clock_id, :integer
  end
end
