require 'factory_girl'

FactoryGirl.define do
  factory :game_goalie do
    game { build(:game, :with_goalie) }
    after(:build) do |game_goalie|
      game_goalie.goalie ||= game_goalie.game.game_players.find {|p| p.role == :goalie }.player
    end
  end
end
