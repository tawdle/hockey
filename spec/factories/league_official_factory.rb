require 'factory_girl'

FactoryGirl.define do
  factory :league_official do
    league
    official
  end
end
