class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status
      t.references :home_team
      t.references :visiting_team
      t.references :location
      t.datetime :start
      t.integer :home_team_score
      t.integer :visiting_team_score
      t.timestamps
    end
    add_index :games, :home_team_id
    add_index :games, :visiting_team_id
    add_index :games, :location_id
    add_index :games, :start
  end
end
