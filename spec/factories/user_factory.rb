require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "abcd1234"

    after(:build) do |user|
      user.system_name.name = "User_#{rand(1_000_000)}"
    end
  end

  factory :admin, :parent => :user do
    after(:create) do |u|
      create(:authorization, :user => u, :role => :admin)
    end
  end
end

