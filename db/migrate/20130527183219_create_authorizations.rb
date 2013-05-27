class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user
      t.string :role
      t.references :authorizable, :polymorphic => true
    end
  end
end
