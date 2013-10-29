require 'factory_girl'

FactoryGirl.define do
  factory :mention do
    activity_feed_item
    system_name
  end
end
