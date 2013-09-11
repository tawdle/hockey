require 'factory_girl'

FactoryGirl.define do
  factory :game do
    association :home_team, :factory => :team
    association :visiting_team, :factory => :team
    location
    start_time { 1.week.from_now }

    trait :active do
      after(:build) do |game|
        game.activate!
      end
    end

    trait :playing do
      after(:build) do |game|
        game.activate!
        game.start!
      end
    end
  end
end
