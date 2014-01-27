require 'spec_helper'

describe Goal do
  let(:goal) { FactoryGirl.build(:goal, :with_players) }
  let(:user) { FactoryGirl.build(:user) }

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
    it "stops the game clock" do
      goal.game.should_receive(:pause)
      goal.save!
    end

    let(:action) { goal.save! }
    let(:type) { Feed::NewGoal }
    it_behaves_like "an action that creates an activity feed item"
  end
  describe "#destroy" do
    let(:setup) { goal.updater = user }
    let(:action) { goal.destroy }
    let(:type) { Feed::CancelGoal }
    it_behaves_like "an action that creates an activity feed item"
  end
end
