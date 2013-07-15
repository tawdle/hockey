require 'factory_girl'

FactoryGirl.define do
  factory :team do
    sequence :full_name do |n|
      "Test Team #{n}"
    end
    league
    manager { build(:user) }
    association :user
  end
end

