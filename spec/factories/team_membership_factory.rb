require 'factory_girl'

FactoryGirl.define do 
  factory :team_membership do
    member { build(:user) }
    team
  end
end
