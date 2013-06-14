require 'factory_girl'

FactoryGirl.define do
  factory :authorization do
    user
    role :admin

    trait :with_authorizable do
      role :manager
      authorizable { build(:team) }
    end
  end
end

