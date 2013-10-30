class AddTypeToLeague < ActiveRecord::Migration
  def up
    add_column :leagues, :type, :string
    League.update_all("type = 'League'")

    create_table :league_tournaments do |t|
      t.references :league
      t.references :tournament
      t.timestamps
    end
    add_index :league_tournaments, :league_id
    add_index :league_tournaments, :tournament_id
  end

  def down
    remove_column :leagues, :type
    drop_table :league_tournaments
  end
end
