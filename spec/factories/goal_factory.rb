require 'factory_girl'

FactoryGirl.define do
  factory :goal do
    association :creator, :factory => :user
    team { build(:team, :with_players) }
    period "3"
    after(:build) do |goal|
      goal.game = build(:game, :home_team => goal.team)
      goal.player = goal.team.members.first
      goal.assisting_player = goal.team.members.last
    end
  end
end
