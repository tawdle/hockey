require 'factory_girl'

FactoryGirl.define do
  factory :penalty do
    game { build(:game, :playing, :with_players) }
    period 2
    elapsed_time 127.4
    category "minor"
    infraction "boarding"
    minutes 2
    after(:build) do |penalty|
      penalty.player ||= penalty.game.game_players.first.player
    end
  end
end
