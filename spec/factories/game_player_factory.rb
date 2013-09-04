require 'factory_girl'

FactoryGirl.define do
  factory :game_player do
    ignore do
      team { build(:team) }
    end
    after(:build) do |game_player, evaluator|
      game_player.game ||= create(:game, :home_team => evaluator.team)
      game_player.player ||= create(:player, :team => evaluator.team)
    end
  end
end
