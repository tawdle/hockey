require 'spec_helper'

describe GoalPlayer do
  let(:goal_player) { FactoryGirl.build(:goal_player) }

  describe "#validations" do
    it "creates a valid object" do
      goal_player.should be_valid
    end
    it "requires a goal" do
      goal_player.goal = nil
      goal_player.should_not be_valid
    end
    it "requires a player" do
      goal_player.player = nil
      goal_player.should_not be_valid
    end
    it "prevents duplicate players" do
      other_goal_player = FactoryGirl.create(:goal_player, :goal => goal_player.goal, :player => goal_player.player)
      goal_player.should_not be_valid
    end
  end
end
