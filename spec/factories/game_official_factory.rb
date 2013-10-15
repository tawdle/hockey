require 'factory_girl'

FactoryGirl.define do
  factory :game_official do
    game
    official
    role :referee
  end
end
