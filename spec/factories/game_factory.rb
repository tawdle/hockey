require 'factory_girl'

FactoryGirl.define do
  factory :game do
    association :home_team, :factory => :team
    association :visiting_team, :factory => :team
    location
    start_time { 1.week.from_now }
  end
end
