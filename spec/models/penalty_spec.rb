require 'spec_helper'

describe Penalty do
  let(:penalty) { FactoryGirl.build(:penalty) }

  describe "#validations" do
    it "builds a valid object" do
      penalty.should be_valid
    end
    it "requires a game" do
      penalty.game = nil
      penalty.should_not be_valid
    end
    it "requires a penalizable" do
      penalty.penalizable = nil
      penalty.should_not be_valid
    end
    it "requires a legal category" do
      penalty.category = :really_really_bad
      penalty.should_not be_valid
    end
    it "requires a legal infraction" do
      penalty.infraction = :picking_the_nose
      penalty.should_not be_valid
    end
    it "requires a team" do
      penalty.team = nil
      penalty.should_not be_valid
    end
    it "requires the team to be in the game" do
      penalty.team = FactoryGirl.create(:team)
      penalty.should_not be_valid
    end
    it "requires the penalized player to be on the team" do
      penalty.team = penalty.game.visiting_team
      penalty.should_not be_valid
    end
    it "requires the penalized player to be in game" do
      penalty.penalizable = FactoryGirl.build(:player)
      penalty.should_not be_valid
    end
    it "requires the serving player to be in game" do
      penalty.serving_player = FactoryGirl.build(:player)
      penalty.should_not be_valid
    end
    it "requires the serving player to be on the same team" do
      penalty.serving_player = penalty.game.opposing_team(penalty.penalizable.team).players.first
      penalty.should_not be_valid
    end
    it "requires a valid period" do
      penalty.period = 17
      penalty.should_not be_valid
    end
    it "requires a valid elapsed_time" do
      penalty.elapsed_time = nil
      penalty.should_not be_valid
    end
    it "requires a valid penalty length" do
      penalty.minutes = 0
      penalty.should_not be_valid
    end
    it "allows no penalty length (for untimed penalties)" do
      penalty.minutes = nil
      penalty.should be_valid
    end
  end
  describe "#start" do
    context "with a 'created' penalty" do
      let(:penalty) { FactoryGirl.create(:penalty) }

      it "should create a timer" do
        penalty.game # reference to create game's timer
        expect {
          penalty.start!
        }.to change { Timer.count }.by(1)
        penalty.timer.should be_present
      end
    end
    context "with a 'paused' penalty" do
      let(:penalty) { FactoryGirl.create(:penalty) }
      before do
        penalty.start!
        penalty.pause!
      end
      it "should restart the timer" do
        expect {
          penalty.start!
        }.to change { penalty.timer.state }.to("running")
      end
    end
  end

  describe "#pause" do
    context "with a 'running' penalty" do
      let(:penalty) { FactoryGirl.create(:penalty) }
      before do
        penalty.start!
      end
      it "should pause the timer" do
        expect {
          penalty.pause!
        }.to change { penalty.timer.state }.to("paused")
      end
    end
  end

  describe ".start_eligible_penalties" do
    context "with 3 pending penalties" do
      let(:game) { FactoryGirl.create(:game, :with_players) }

      before do
        @pending_penalties = [
          FactoryGirl.create(:penalty, :game => game, :penalizable => game.home_team.players.first),
          FactoryGirl.create(:penalty, :game => game, :penalizable => game.home_team.players.last),
          FactoryGirl.create(:penalty, :game => game, :penalizable => game.home_team.players.first)
        ]
        @eldest_sibling = @pending_penalties[0]
        @younger_sibling = @pending_penalties[2]
      end

      context "with no paused penalties" do
        it "starts 2 pending penalties" do
          expect {
            Penalty.start_eligible_penalties(game)
          }.to change { game.reload.penalties.started.count }.from(0).to(2)
        end
        it "starts an eldest sibling with its younger siblings' offsets" do
          Penalty.start_eligible_penalties(game)
          @eldest_sibling.reload.should be_running
          @younger_sibling.reload.should_not be_running
          @eldest_sibling.timer.offset.should == @younger_sibling.minutes.minutes
        end

      end
      context "with 1 paused penalty" do
        before do
          @paused_penalty = FactoryGirl.create(:penalty, :paused, :game => game, :penalizable => game.players.first)
        end
        it "starts 1 paused penalty" do
          expect {
            Penalty.start_eligible_penalties(game)
          }.to change { @paused_penalty.reload.state }.from("paused").to("running")
        end
        it "starts 1 pending penalty" do
          expect {
            Penalty.start_eligible_penalties(game)
          }.to change { @pending_penalties.select {|p| p.reload.running?}.count }.from(0).to(1)
        end
      end
      context "with 3 paused penalties" do
        before do
          @paused_penalties = FactoryGirl.create_list(:penalty, 2, :paused, :game => game, :penalizable => game.players.first)
        end
        it "starts 2 paused penalties" do
          expect {
            Penalty.start_eligible_penalties(game)
          }.to change { @paused_penalties.select {|p| p.reload.running?}.count}.from(0).to(2)
        end
        it "starts none of the pending penalties" do
          expect {
            Penalty.start_eligible_penalties(game)
          }.not_to change { @pending_penalties.select {|p| p.reload.running?}.count}.from(0)
        end
      end
    end
  end
end
