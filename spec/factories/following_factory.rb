require 'factory_girl'

FactoryGirl.define do
  factory :following do
    user
    followable { build(:user) }
  end
end
