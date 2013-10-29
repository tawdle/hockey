require 'factory_girl'

FactoryGirl.define do
  factory :following do
    user
    system_name
  end
end
