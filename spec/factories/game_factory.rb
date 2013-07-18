require 'factory_girl'

FactoryGirl.define do
  factory :game do
    status :scheduled
    association :home_team, :factory => :team
    association :visiting_team, :factory => :team
    location
    start { 1.week.from_now }
  end
end
