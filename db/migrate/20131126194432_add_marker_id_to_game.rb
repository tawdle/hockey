class AddMarkerIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :marker_id, :integer
  end
end
