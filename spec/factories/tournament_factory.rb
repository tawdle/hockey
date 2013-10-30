require 'factory_girl'

FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |n| "Tournament #{n}" }
    division :bantam
  end
end
