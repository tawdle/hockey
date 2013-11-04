require 'factory_girl'

FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |n| "Tournament #{n}" }
    division :bantam

    trait :with_manager do
      after :build do |tournament|
        tournament.authorizations << build(:authorization, :authorizable => tournament, :role => :manager)
      end
    end

    trait :with_marker do
      after :build do |tournament|
        tournament.authorizations << build(:authorization, :authorizable => tournament, :role => :marker)
      end
    end

    trait :with_teams do
      after(:build) do |tournament|
        tournament.teams.build
        tournament.teams.build
      end
    end
  end
end
