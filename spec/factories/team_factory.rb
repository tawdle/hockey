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
      members { [ build(:user), build(:user) ] }
    end
  end
end

