require 'factory_girl'

FactoryGirl.define do
  factory :staff_member do
    sequence(:name) {|n| "staff member #{n}" }
    team
    role :assistant_coach
  end
end
