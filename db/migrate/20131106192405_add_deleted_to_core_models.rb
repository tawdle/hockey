class AddDeletedToCoreModels < ActiveRecord::Migration
  def change
    [:games, :leagues, :locations, :officials, :players, :staff_members, :teams].each do |table|
      add_column table, :deleted_at, :datetime
    end
  end
end
