class RenameRecordersToMarkers < ActiveRecord::Migration
  def up
    Authorization.update_all("role = 'marker'", "role = 'recorder'")
  end

  def down
    Authorization.update_all("role = 'recorder'", "role = 'marker'")
  end
end
