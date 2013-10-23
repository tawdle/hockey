require 'spec_helper'

describe GameOfficialsController do
  let(:game) { FactoryGirl.create(:game) }
  let(:league) { game.home_team.league }
  let(:officials) { FactoryGirl.create_list(:official, 3, :leagues => [league]) }
  let(:referee) { officials[0] }
  let(:linesmen) { officials[1..-1] }
  let(:marker) { FactoryGirl.create(:authorization, :role => :marker, :authorizable => league).user }

  context "with a signed in marker" do
    before { sign_in(marker) }

    describe "#edit" do
      def do_request
        get :edit, :game_id => game.to_param
      end

      it "works" do
        do_request
        response.should be_success
        response.should render_template("edit")
      end
    end

    describe "#update" do
      def do_request
        post :update, :game_id => game.to_param, :game => { :referee_ids => [referee.to_param], :linesman_ids => linesmen.collect(&:to_param) }
      end
      it "works" do
        expect {
          do_request
          response.should redirect_to(game)
        }.to change { game.reload.game_officials.count }.from(0).to(3)
      end
    end
  end
end
