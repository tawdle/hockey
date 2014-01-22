require 'factory_girl'

FactoryGirl.define do
  factory :mention do
    activity_feed_item { build(:feed_user_post) }
    mentionable { build(:player) }
  end
end
