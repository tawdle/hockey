require 'factory_girl'

FactoryGirl.define do
  factory :league do
    sequence :name do |n|
      "league #{n}"
    end
  end
end
