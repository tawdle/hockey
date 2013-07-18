require 'spec_helper'

describe GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_team) }
  let(:manager) { league.managers.first }
  let(:game) { FactoryGirl.create(:game, :home_team => league.teams.first) }

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

    describe "#edit_score" do
      def do_request
        get :edit_score, :league_id => league.to_param, :id => game.to_param
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
          :start => 1.week.from_now }
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
        put :update, :league_id => league.to_param, :id => game.to_param, :game => { :start => new_start }
      end

      it "should reschedule to a new date" do
        expect {
          do_request
        }.to change { game.reload.start.to_i }.to(new_start.to_i)
      end
    end
    describe "#update_score" do
      def do_request
        request.env["HTTP_REFERER"] = "/"
        put :update_score, :league_id => league.to_param, :id => game.to_param, :game => { :home_team_score => 3, :visiting_team_score => 2 }
      end

      before do
        game.update_attribute(:start, 2.hours.ago)
      end

      it "should change the score" do
        expect {
          do_request
        }.to change { game.reload.home_team_score }.to(3)
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
        }.to change { game.reload.status }.to(:canceled)
      end
    end
  end
end
