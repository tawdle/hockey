require 'factory_girl'

FactoryGirl.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
  end
end
