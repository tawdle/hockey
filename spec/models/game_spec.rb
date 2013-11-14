require 'spec_helper'

describe Game do
  describe "#validations" do
    let(:game) { FactoryGirl.build(:game) }

    it "creates a valid object" do
      game.should be_valid
    end

    it "requires a valid state" do
      game.state = :foo
      game.should_not be_valid
    end

    it "requires a home team" do
      game.home_team = nil
      game.should_not be_valid
    end

    it "requires a visiting team" do
      game.visiting_team = nil
      game.should_not be_valid
    end

    it "requires different home and visiting teams" do
      game.visiting_team = game.home_team
      game.should_not be_valid
    end

    it "requires a league" do
      game.league = nil
      game.should_not be_valid
    end
    it "requires a location" do
      game.location = nil
      game.should_not be_valid
    end

    it "requires a start_time" do
      game.start_time = nil
      game.should_not be_valid
    end

    it "requires the start_time be in the future" do
      game.start_time = 1.week.ago
      game.should_not be_valid
    end

    context "with an active game" do
      let(:game) { FactoryGirl.create(:game, :active) }

      it "prevents changing the start_time" do
        game.start_time = 3.weeks.from_now
        game.should_not be_valid
      end

      it "prevents changing the location" do
        game.location = FactoryGirl.build(:location)
        game.should_not be_valid
      end
    end
  end

  describe "#states" do
    let(:game) { FactoryGirl.build(:game) }

    before do
      game.should_receive(:ready_to_activate?).and_return(true)
    end

    it "goes through entire lifecycle" do
      game.activate!
      game.start!
      game.pause!
      game.start!
      game.stop!
      game.finish!
      game.complete!
    end
  end

  describe "#start" do
    context "with an activated game" do
      let(:game) { FactoryGirl.build(:game) }

      before do
        game.should_receive(:ready_to_activate?).and_return(true)
        game.activate!
      end

      it "sets the start time when the game is first started" do
        expect {
          game.start!
        }.to change { game.started_at }.from(nil)
      end

      it "doesn't change started_at on subsequent starts" do
        game.start!
        game.pause!

        expect {
          game.start!
        }.not_to change { game.started_at }
      end

      it "notifies the penalty subsystem of its changed state" do
        Penalty.should_receive(:start_eligible_penalties).with(game)
        game.start!
      end
    end
  end

  describe "#pause" do
    context "with a playing game" do
      let(:game) { FactoryGirl.build(:game) }

      before do
        game.should_receive(:ready_to_activate?).and_return(true)
        game.activate!
        game.start!
      end

      it "notifies the penalty subsystem of its changed state" do
        Penalty.should_receive(:pause_running_penalties).with(game)
        game.pause!
      end
    end
  end

  describe "#finish" do
    context "with a stopped game" do
      let(:game) { FactoryGirl.build(:game) }

      before do
        game.should_receive(:ready_to_activate?).and_return(true)
        game.activate!
        game.start!
        game.stop!
      end

      it "should set ended_at" do
        expect { game.finish! }.to change { game.ended_at }.from(nil)
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

    describe "#start" do
      before do
        game.should_receive(:ready_to_activate?).and_return(true)
        game.activate!
      end

      let(:action) { game.start! }
      it_behaves_like "an action that creates an activity feed item"
    end
  end

  describe "#readonly attributes" do
    let(:game) { FactoryGirl.build(:game) }
    let(:new_team) { FactoryGirl.build(:team) }
    it "does not update home_team" do
      game.save!
      expect {
        game.update_attributes!(:home_team => new_team)
      }.not_to change { game.reload.home_team }
    end
  end
  it_behaves_like "a model that implements soft delete"
end
