require 'factory_girl'

FactoryGirl.define do
  factory :player_claim do
    creator { build(:user) }
    player

    trait :approved do
      state { :approved }
      manager {|player_claim| player_claim.player.team.managers.first }
    end

    trait :denied do
      state { :denied }
      manager {|player_claim| player_claim.player.team.managers.first }
    end
  end
end
