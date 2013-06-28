require 'factory_girl'

FactoryGirl.define do
  factory :league do
    sequence :name do |n|
      "league #{n}"
    end

    trait :with_manager do
      after :create do |league|
        create(:authorization, :authorizable => league, :role => :manager)
      end
    end
  end
end
