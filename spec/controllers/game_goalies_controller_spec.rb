require 'spec_helper'

describe GameGoaliesController do
  let(:game) { FactoryGirl.create(:game, :with_goalie, :with_marker) }
  let(:goalie) { game.game_players.where(:role => :goalie).first.player }
  let(:marker) { game.league.markers.first }

  context "with a logged in marker" do
    before { sign_in(marker) }

    describe "#new" do
      def do_request
        get :new, :game_id => game.to_param
      end

      it "should render the new form" do
        do_request
        response.should be_success
        response.body.should render_template("new")
      end
    end

    describe "#create" do
      def do_request
        post :create, :game_id => game.to_param, :game_goalie => {:goalie_id => goalie.to_param }
      end

      it "should create the game goalie" do
        expect {
          do_request
          response.should redirect_to(game)
        }.to change { GameGoalie.count }.by(1)
      end
    end
  end
end
