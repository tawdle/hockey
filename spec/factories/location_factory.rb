require 'factory_girl'

FactoryGirl.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    address_1 "1234 Main Street"
    city "Bumbletown"
    state "Euphoria"
    zip "96161"
    country "CA"
    telephone "867-5309"
    email "foo@barr.com"
    website "http://foo.bar.com/"

    after(:build) do |location|
      location.system_name.name ||= location.name.gsub(/\s+/, "")
    end
  end
end
