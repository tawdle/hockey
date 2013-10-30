require 'spec_helper'

describe Goal do
  let(:goal) { FactoryGirl.build(:goal, :with_players) }

  describe "#validations" do
    it "creates a valid object" do
      goal.should be_valid
    end
    it "requires a creator" do
      goal.creator = nil
      goal.should_not be_valid
    end
    it "requires a game" do
      goal.game = nil
      goal.should_not be_valid
    end
    it "requires a valid period" do
      goal.period = "foo"
      goal.should_not be_valid
    end
    it "requires that the team be in the game" do
      goal.team = FactoryGirl.build(:team)
      goal.should_not be_valid
    end
  end
  describe "#create" do
    let(:action) { goal.save! }
    let(:count) { 2 }
    it_behaves_like "an action that creates an activity feed item"
  end
  describe "#destroy" do
    let(:action) { goal.save!; goal.destroy }
    let(:count) { 3 }
    it_behaves_like "an action that creates an activity feed item"
  end
end
