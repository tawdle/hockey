require 'factory_girl'

FactoryGirl.define do
  factory :team do
    sequence :name do |n|
      "Test Team #{n}"
    end
    league
    manager { build(:user) }

    after(:build) do |team|
      team.system_name.name ||= team.name.gsub(/\s+/, "")
    end

    trait :with_players do
      players { [ build(:player, :team => nil), build(:player, :team => nil) ] }
      after(:build) do |team|
        team.players.each do |player|
          player.team = team
        end
      end
    end
    trait :with_staff do
      staff_members { [ build(:staff_member), build(:staff_member) ] }
    end
  end
end

