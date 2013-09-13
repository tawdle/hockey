require 'factory_girl'

FactoryGirl.define do
  factory :team do
    sequence :full_name do |n|
      "Test Team #{n}"
    end
    league
    manager { build(:user) }
    association :user

    trait :with_players do
      players { [ build(:player, :team => nil), build(:player, :team => nil) ] }
      after(:build) do |team|
        team.players.each do |player|
          player.team = team
        end
      end
    end
  end
end

