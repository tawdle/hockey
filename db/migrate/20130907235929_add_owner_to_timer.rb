class AddOwnerToTimer < ActiveRecord::Migration
  def change
    add_column :timers, :owner_type, :string
    add_column :timers, :owner_id, :integer
  end
end
