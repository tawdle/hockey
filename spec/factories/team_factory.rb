require 'factory_girl'

FactoryGirl.define do
  factory :team do
    sequence :name do |n|
      "team #{n}"
    end
  end
end

