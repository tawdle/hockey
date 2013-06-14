require 'factory_girl'

FactoryGirl.define do
  factory :team do
    sequence :name do |n|
      "team #{n}"
    end
    league
    manager { build(:user) }
  end
end

