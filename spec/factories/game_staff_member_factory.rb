require 'factory_girl'

FactoryGirl.define do
  factory :game_staff_member do
    ignore do
      team { build(:team) }
    end
    game { build(:game, :home_team => team) }
    staff_member { build(:staff_member, :team => team) }
  end
end
