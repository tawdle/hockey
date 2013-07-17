require 'factory_girl'

FactoryGirl.define do
  factory :mention do
    activity_feed_item
    user
  end
end
