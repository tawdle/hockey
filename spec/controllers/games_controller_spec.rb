require 'spec_helper'

describe GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_team) }
  let(:manager) { league.managers.first }

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
  end
end
