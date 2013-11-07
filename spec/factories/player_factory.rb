require 'factory_girl'

FactoryGirl.define do
  factory :player do
    association :creator, :factory => :user
    team
    sequence(:name) { |n| "Player #{n}" }
    sequence(:jersey_number) {|n| n }
    role :player

    trait :with_user do
      user
    end
  end
end
