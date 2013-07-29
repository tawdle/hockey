require 'factory_girl'

FactoryGirl.define do 
  factory :team_membership do
    creator { build(:user) }
    member { build(:user) }
    team
  end
end
