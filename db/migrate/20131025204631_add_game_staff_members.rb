class AddGameStaffMembers < ActiveRecord::Migration
  def change
    create_table :game_staff_members do |t|
      t.references :game, :null => false
      t.references :staff_member, :null => false
      t.string :role, :null => false, :default => :assistant_coach
    end
    add_index :game_staff_members, :game_id
    add_index :game_staff_members, :staff_member_id
  end
end
