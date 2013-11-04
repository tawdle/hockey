class DropLeagueOfficials < ActiveRecord::Migration
  class LeagueOfficial < ActiveRecord::Base
    attr_accessible :league_id, :official_id
  end

  def up
    add_column :officials, :league_id, :integer
    add_index :officials, :league_id

    LeagueOfficial.all.each do |league_official|
      execute("update officials set league_id = #{league_official.league_id} where id = #{league_official.official_id}")
    end

    drop_table :league_officials
  end

  def down
    create_table :league_officials do |t|
      t.references :league
      t.references :official
    end

    Official.all.each do |official|
      LeagueOfficial.create!(:league_id => official.league_id, :official_id => official.id)
    end
  end
end
