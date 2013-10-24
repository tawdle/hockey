class CreateStaffMembers < ActiveRecord::Migration
  def change
    create_table :staff_members do |t|
      t.string :name, :null => false
      t.references :team, :null => false
      t.string :role, :default => :assistant_coach
      t.references :user
    end
    add_index :staff_members, :team_id
    add_index :staff_members, :user_id
  end
end
