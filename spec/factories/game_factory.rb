require 'factory_girl'

FactoryGirl.define do
  factory :game do
    association :home_team, :factory => :team
    association :visiting_team, :factory => :team
    location
    start_time { 1.week.from_now }

    trait :with_players do
      home_team { build(:team, :with_players) }
      visiting_team { build(:team, :with_players) }
      after(:build) do |game|
        game.players = game.home_team.players + game.visiting_team.players
      end
    end

    trait :active do
      after(:build) do |game|
        game.state = "active"
        game.period = 0
        game.build_clock
      end
    end

    trait :playing do
      after(:build) do |game|
        game.state = "playing"
        game.period = 0
        game.build_clock
      end
    end

    trait :finished do
      after(:build) do |game|
        game.state = "finished"
      end
    end
  end
end
