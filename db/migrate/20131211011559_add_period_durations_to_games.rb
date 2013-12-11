class AddPeriodDurationsToGames < ActiveRecord::Migration
  class Game < ActiveRecord::Base; end

  def up
    add_column :games, :period_durations, :json
    Game.find_each do |game|
      game.update_attribute(:period_durations, ([game.period_duration] * ::Game::Periods.length).to_json)
    end
    remove_column :games, :period_duration
  end

  def down
    add_column :games, :period_duration, :integer, :default => 900

    Game.find_each do |game|
      game.update_attribute(:period_duration, game.period_durations[0])
    end

    remove_column :games, :period_durations
  end
end
