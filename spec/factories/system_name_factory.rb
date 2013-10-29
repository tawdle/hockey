require 'factory_girl'

FactoryGirl.define do
  factory :system_name do
    sequence(:name) { |n| "Name_#{n}" }
    after(:build) do |system_name|
      system_name.nameable ||= FactoryGirl.build(:user, :system_name => system_name)
    end
  end
end
