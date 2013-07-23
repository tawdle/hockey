require 'spec_helper'

describe Game do
  describe "#validations" do
    let(:game) { FactoryGirl.build(:game) }

    it "should create a valid object" do
      game.should be_valid
    end

    it "should require a valid state" do
      game.state = :foo
      game.should_not be_valid
    end

    it "should require a home team" do
      game.home_team = nil
      game.should_not be_valid
    end

    it "should require a visiting team" do
      game.visiting_team = nil
      game.should_not be_valid
    end

    it "should require different home and visiting teams" do
      game.visiting_team = game.home_team
      game.should_not be_valid
    end

    it "should require a location" do
      game.location = nil
      game.should_not be_valid
    end

    it "should require a start_time" do
      game.start_time = nil
      game.should_not be_valid
    end

    it "should require the start_time be in the future" do
      game.start_time = 1.week.ago
      game.should_not be_valid
    end

    it "should prevent setting scores for a game not yet started" do
      game.home_team_score = 2
      game.should_not be_valid
    end

    context "with an active game" do
      let(:game) { FactoryGirl.create(:active_game) }

      it "should allow setting scores" do
        game.home_team_score = 2
        game.should be_valid
      end

      it "should prevent changing the start_time after the game has started" do
        game.start_time = 3.weeks.from_now
        game.should_not be_valid
      end

      it "should prevent changing the location after the game has started" do
        game.location = FactoryGirl.build(:location)
        game.should_not be_valid
      end
    end
    context "with a finished game" do
      let(:game) { FactoryGirl.create(:finished_game) }

      it "should prevent changing scores" do
        game.visiting_team_score = 7
        game.should_not be_valid
      end
    end
  end

  describe "actions that create an activity feed item" do
    let(:game) { FactoryGirl.build(:game) }
    let(:saved_game) { FactoryGirl.create(:game) }
    let(:new_start_time) { 3.weeks.from_now }
    let(:new_location) { FactoryGirl.create(:location) }

    describe "#create" do
      let(:action) { game.save! }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update start_time" do
      let(:action) { saved_game.update_attributes(:start_time => new_start_time) }
      let(:count ) { 2 }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update location" do
      let(:action) { saved_game.update_attributes(:location => new_location) }
      let(:count) { 2 }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update start_time AND location" do
      let(:action) { saved_game.update_attributes(:start_time => new_start_time, :location => new_location) }
      let(:count) { 3 }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#cancel" do
      let(:action) { saved_game.cancel! }
      let(:count) { 2 }
      it_behaves_like "an action that creates an activity feed item"
    end
  end

  describe "#readonly attributes" do
    let(:game) { FactoryGirl.build(:game) }
    let(:new_team) { FactoryGirl.build(:team) }
    it "should not update home_team" do
      game.save!
      expect {
        game.update_attributes!(:home_team => new_team)
      }.not_to change { game.reload.home_team }
    end
  end
end
