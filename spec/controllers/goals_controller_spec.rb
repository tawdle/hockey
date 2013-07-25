require 'spec_helper'

describe GoalsController do
  let(:league) { FactoryGirl.create(:league, :with_recorder) }
  let(:recorder) { league.recorders.first }
  let(:team) { FactoryGirl.create(:team, :with_players, :league => league) }
  let(:game) { FactoryGirl.create(:game, :visiting_team => team) }
  let(:player) { team.players.first }

  context "with a signed in recorder" do
    before { sign_in(recorder) }

    describe "#new" do
      def do_request
        get :new, :game_id => game.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#create" do
      def do_request
        post :create, :game_id => game.to_param, :goal => { :game_id => game.to_param, :team_id => team.to_param, :player_id => player.to_param, :period => "OT" }
      end
      it "should create a goal" do
        expect {
          do_request
        }.to change { Goal.count }.by(1)
      end
    end
  end
end