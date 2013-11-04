require 'factory_girl'

FactoryGirl.define do
  factory :official do
    sequence(:name) { |n| "Test Official #{n}" }
    league
  end
end
