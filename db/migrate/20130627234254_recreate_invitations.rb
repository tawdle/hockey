class RecreateInvitations < ActiveRecord::Migration
  def up
    drop_table :invitations
    create_table :invitations, :id => false do |t|
      t.string :code, :nil => false
      t.string :state
      t.references :creator, :nil => false
      t.string :email, :nil => false
      t.string :predicate, :nil => false
      t.references :target, :polymorphic => true, :nil => false
      t.timestamps
    end
    execute "ALTER TABLE invitations ADD PRIMARY KEY (code);"
    add_index :invitations, [:email, :predicate, :target_type, :target_id], :name => :invitations_unique, :unique => true
    # See http://stackoverflow.com/questions/1200568/using-rails-how-can-i-set-my-primary-key-to-not-be-an-integer-typed-column
  end

  def down
  end
end
