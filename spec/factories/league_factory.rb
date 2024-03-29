require 'factory_girl'

FactoryGirl.define do
  factory :league do
    sequence :name do |n|
      "league #{n}"
    end
    classification :aa
    division :bantam

    after(:build) do |league|
      league.system_name.name ||= league.name.gsub(/\s+/, "")
    end

    trait :with_manager do
      after :create do |league|
        create(:authorization, :authorizable => league, :role => :manager)
      end
    end

    trait :with_marker do
      after :create do |league|
        create(:authorization, :authorizable => league, :role => :marker)
      end
    end

    trait :with_team do
      after :create do |league|
        create(:team, :league => league)
      end
    end
  end
end
