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

  describe ".for_user" do
    it "finds games involving teams on which I am a player" do
      @game = FactoryGirl.create(:game, :with_players)
      @player = @game.home_team.players.first
      @user = FactoryGirl.create(:user)
      @player.update_attribute(:user_id, @user.id)

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving teams which I managage" do
      @game = FactoryGirl.create(:game)
      @user = @game.home_team.managers.first

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving teams that are part of leagues that I mark" do
      @game = FactoryGirl.create(:game)
      @user = FactoryGirl.create(:user)
      Authorization.create!(:user => @user, :authorizable => @game.league, :role => :marker)

      Game.for_user(@user).should include(@game)
    end
    it "finds games at a location that I manage" do
      @game = FactoryGirl.create(:game)
      @location = @game.location
      @user = FactoryGirl.create(:user)
      Authorization.create!(:user => @user, :authorizable => @game.location, :role => :manager)

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving players that I follow" do
      @game = FactoryGirl.create(:game, :with_players)
      @player = @game.home_team.players.first
      @user = FactoryGirl.create(:user)
      @player.followers << @user

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving teams that I follow" do
      @game = FactoryGirl.create(:game)
      @team = @game.home_team
      @user = FactoryGirl.create(:user)
      @team.followers << @user

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving leagues that I follow" do
      @game = FactoryGirl.create(:game)
      @league = @game.league
      @user = FactoryGirl.create(:user)
      @league.followers << @user

      Game.for_user(@user).should include(@game)
    end
    it "finds games at a location that I follow" do
      @game = FactoryGirl.create(:game)
      @location = @game.location
      @user = FactoryGirl.create(:user)
      @location.followers << @user

      Game.for_user(@user).should include(@game)
    end
    it "finds games involving a user that I follow" do
      @game = FactoryGirl.create(:game, :with_players)
      @player = @game.home_team.players.first
      @followed_user = FactoryGirl.create(:user)
      @player.update_attribute(:user_id, @followed_user.id)
      @user = FactoryGirl.create(:user)
      @followed_user.followers << @user

      Game.for_user(@user).should include(@game)
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
    let(:user) { FactoryGirl.create(:user) }
    let(:saved_game) { FactoryGirl.create(:game) }
    let(:new_start_time) { 3.weeks.from_now }
    let(:new_location) { FactoryGirl.create(:location) }

    describe "#create" do
      let(:setup) { game.updater = user }
      let(:action) { game.save! }
      let(:type) { Feed::NewGame }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update start_time" do
      let(:action) { saved_game.update_attributes(:start_time => new_start_time, :updater => user) }
      let(:type) { Feed::ChangeGameTime }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update location" do
      let(:action) { saved_game.update_attributes(:location => new_location, :updater => user) }
      let(:type) { Feed::ChangeGameLocation }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#update start_time AND location" do
      let(:setup) { reference = [saved_game, new_location, user] }
      let(:action) { saved_game.update_attributes(:start_time => new_start_time, :location => new_location, :updater => user) }
      let(:count) { 2 }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#cancel" do
      let(:setup) { saved_game.updater = user }
      let(:action) { saved_game.cancel! }
      it_behaves_like "an action that creates an activity feed item"
    end

    describe "#start" do
      before do
        game.updater = user
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
