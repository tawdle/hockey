require 'factory_girl'

FactoryGirl.define do
  factory :goal_player do
    goal
    player
  end
end
