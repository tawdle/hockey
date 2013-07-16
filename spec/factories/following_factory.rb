require 'factory_girl'

FactoryGirl.define do
  factory :following do
    user
    association :target, :factory => :user
  end
end
