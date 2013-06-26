class CreateInvitation < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :code, :nil => false
      t.string :state
      t.references :creator, :nil => false
      t.string :email, :nil => false
      t.string :action, :nil => false
      t.references :target, :polymorphic => true, :nil => false
      t.timestamps
    end
    add_index :invitations, [:email, :action, :target_type, :target_id], :name => :invitations_unique, :unique => true
  end
end
