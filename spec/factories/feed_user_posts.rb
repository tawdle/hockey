# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feed_user_post, :class => 'Feed::UserPost', :parent => :activity_feed_item do
    creator { build(:user) }
    message "Hello everyone!"
  end
end
