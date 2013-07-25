require 'spec_helper'

describe GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_team) }
  let(:manager) { league.managers.first }
  let(:game) { FactoryGirl.create(:game, :home_team => league.teams.first) }

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
          :start_time => 1.week.from_now }
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
        request.env["HTTP_REFERER"] = "/"
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
        request.env["HTTP_REFERER"] = "/"
        delete :destroy, :id => game.to_param
      end

      it "should change the game's state to canceled" do
        expect {
          do_request
        }.to change { game.reload.canceled? }.to(true)
      end
    end
  end
end
