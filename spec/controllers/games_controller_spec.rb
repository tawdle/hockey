require 'spec_helper'

describe GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_marker, :with_team) }
  let(:manager) { league.managers.first }
  let(:team) { league.teams.first }
  let(:game) { FactoryGirl.create(:game, :league => league, :home_team => team) }
  let(:marker) { league.markers.first }

  before do
    request.env["HTTP_REFERER"] = "/"
  end

  describe "#show" do
    def do_request
      get :show, :id => game.to_param
    end

    it "should work" do
      do_request
      response.should be_ok
    end
  end

  context "with a logged in league manager" do
    before { sign_in(manager) }

    describe "#new" do
      def do_request
        get :new, :league_id => league.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :league_id => league.to_param, :id => game.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#create" do
      let(:home_team) { FactoryGirl.create(:team, :league => league) }
      let(:visiting_team) { FactoryGirl.create(:team) }
      let(:location) { FactoryGirl.create(:location) }

      def do_request
        post :create, :league_id => league.to_param, :game => {
          :home_team_id => home_team.to_param,
          :visiting_team_id => visiting_team.to_param,
          :location_id => location.to_param,
          :start_time => 1.week.from_now,
          :period_duration => 20.minutes }
      end
      it "should create a game" do
        expect {
          do_request
        }.to change { Game.count}.by(1)
      end
    end
    describe "#update" do
      let(:new_start) { 2.weeks.from_now.to_datetime }

      def do_request
        put :update, :league_id => league.to_param, :id => game.to_param, :game => { :start_time => new_start }
      end

      it "should reschedule to a new date" do
        expect {
          do_request
        }.to change { game.reload.start_time.to_i }.to(new_start.to_i)
      end
    end
    describe "#destroy" do
      def do_request
        delete :destroy, :id => game.to_param
      end

      it "should change the game's state to canceled" do
        expect {
          do_request
        }.to change { game.reload.canceled? }.to(true)
      end
    end
  end

  context "with a logged in marker" do
    before { sign_in(marker) }

    describe "#activate" do
      def do_request
        post :activate, :id => game.to_param
      end

      #xit "changes the state to active" do
        #expect {
          #do_request
        #}.to change { game.reload.state }.to("active")
      #end
    end

    describe "#start" do
      def do_request
        post :start, :id => game.to_param
      end

      let(:game) { FactoryGirl.create(:game, :active, :league => league) }

      it "changes the state to playing" do
        expect {
          do_request
        }.to change { game.reload.state }.to("playing")
      end
    end

    describe "#pause" do
      def do_request
        post :pause, :id => game.to_param
      end

      let(:game) { FactoryGirl.create(:game, :playing, :league => league) }

      it "changes the state to paused" do
        expect {
          do_request
        }.to change { game.reload.state }.to("paused")
      end
    end

    describe "#stop" do
      def do_request
        post :stop, :id => game.to_param
      end

      let(:game) { FactoryGirl.create(:game, :playing, :league => league) }

      it "changes the state to active" do
        expect {
          do_request
        }.to change { game.reload.state }.to("active")
      end
    end

    describe "#complete" do
      def do_request
        post :complete, :id => game.to_param
      end

      let(:game) { FactoryGirl.create(:game, :finished, :league => league) }

      it "changes the state to completed" do
        expect {
          do_request
        }.to change { game.reload.state }.to("completed")
      end
    end

  end
end
