require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence :name do |n|
      "user_#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "abcd1234"
  end
end

