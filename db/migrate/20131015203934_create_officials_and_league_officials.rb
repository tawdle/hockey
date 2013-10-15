class CreateOfficialsAndLeagueOfficials < ActiveRecord::Migration
  def change
    create_table :officials do |t|
      t.string :name
    end

    create_table :league_officials do |t|
      t.references :league
      t.references :official
    end

    add_index :league_officials, [:league_id, :official_id], :unique => true
    add_index :league_officials, :league_id
    add_index :league_officials, :official_id

    create_table :game_officials do |t|
      t.references :game
      t.references :official
      t.string :role
    end

    add_index :game_officials, [:game_id, :official_id], :unique => true
    add_index :game_officials, :game_id
    add_index :game_officials, :official_id
  end
end
