class CreatePlayerClaims < ActiveRecord::Migration
  def change
    create_table :player_claims do |t|
      t.references :creator
      t.references :player
      t.references :manager
      t.string :state
      t.timestamps
    end
  end
end
