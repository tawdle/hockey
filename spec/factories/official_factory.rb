require 'factory_girl'

FactoryGirl.define do
  factory :official do
    sequence(:name) { |n| "Test Official #{n}" }
    after(:build) do |o|
      o.leagues << FactoryGirl.build(:league)
    end
  end
end
