require 'factory_girl'

FactoryGirl.define do
  factory :game do
    association :home_team, :factory => :team
    association :visiting_team, :factory => :team
    location
    start_time { 1.week.from_now }

    factory :active_game do
      after(:create) do |game|
        game.start!
      end

      factory :finished_game do
        after(:create) do |game|
          game.home_team_score = 2
          game.visiting_team_score = 1
          game.save!
          game.finish!
        end
      end
    end
  end
end
