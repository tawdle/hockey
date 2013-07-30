require 'factory_girl'

FactoryGirl.define do
  factory :invitation do
    association :creator, :factory => :user
    predicate :manage
    sequence(:email) { |n| "testmail+#{n}@example.com" }
    association :target, :factory => :league

    trait :with_fake_user do
      user
    end
  end
end
