require 'factory_girl'

FactoryGirl.define do
  factory :timer do
    duration 15.minutes
  end
end
