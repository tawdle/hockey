require 'spec_helper'

describe PenaltiesController do
  let(:penalty) { FactoryGirl.create(:penalty) }
  let(:game) { penalty.game }

  context "with a logged in recorder" do
    let(:league) { game.home_team.league }
    let(:authorization) { FactoryGirl.create(:authorization, :authorizable => league, :role => :recorder) }
    let(:recorder) { authorization.user }

    before { sign_in(recorder) }

    describe "#create" do
      def do_request
        post :create, :game_id => game.to_param, :penalty => { :period => 2, :elapsed_time => 350, :category => :major, :infraction => :boarding, :minutes => 10, :player_id => penalty.player.to_param }
      end
      it "creates a penalty" do
        expect {
          do_request
        }.to change { Penalty.count }.by(1)
      end
    end

    describe "#update" do
      def do_request
        put :update, :game_id => game.to_param, :id => penalty.to_param, :penalty => {:infraction => "hooking"}
      end
      it "updates the penalty" do
        expect {
          do_request
        }.to change { penalty.reload.infraction }.to(:hooking)
      end
    end
    describe "#destroy" do
      let!(:penalty) { FactoryGirl.create(:penalty) }
      def do_request
        delete :destroy, :game_id => game.to_param, :id => penalty.to_param
      end
      it "destroys the penalty" do
        expect {
          do_request
        }.to change { Penalty.count }.by(-1)
      end
    end
  end

end
