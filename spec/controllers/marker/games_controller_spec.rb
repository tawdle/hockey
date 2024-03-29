require 'spec_helper'

describe Marker::GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_marker, :with_team) }
  let(:manager) { league.managers.first }
  let(:team) { league.teams.first }
  let(:game) { FactoryGirl.create(:game, :league => league, :home_team => team) }
  let(:marker) { league.markers.first }

  before do
    request.env["HTTP_REFERER"] = "/"
  end

  context "with a logged in marker" do
    before { sign_in(marker) }

    describe "#show" do
      def do_request
        get :show, :id => game.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end

      context "with a live game" do
        before do
          Game.any_instance.stub(:live?).and_return(true)
        end

        it "should work" do
          do_request
          response.should render_template("marker/games/show")
          response.should be_ok
        end
      end
    end

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

      let(:game) { FactoryGirl.create(:game, :ready, :league => league) }

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

    describe "#finish" do
      def do_request
        post :finish, :id => game.to_param
      end

      let(:game) { FactoryGirl.create(:game, :playing, :league => league) }

      it "changes the state to finished" do
        expect {
          do_request
        }.to change { game.reload.state }.to("finished")
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
