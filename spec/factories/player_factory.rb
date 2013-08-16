require 'factory_girl'

FactoryGirl.define do
  factory :player do
    association :creator, :factory => :user
    team
    sequence(:jersey_number) {|n| n }

    trait :with_user do
      user
    end
  end
end
