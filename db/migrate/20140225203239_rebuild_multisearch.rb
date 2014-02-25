class RebuildMultisearch < ActiveRecord::Migration
  def up
    [Player, Team, User, Location, League].each do |klass|
      PgSearch::Multisearch.rebuild(klass)
    end
  end

  def down
  end
end
