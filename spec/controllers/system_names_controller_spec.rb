require 'spec_helper'

describe SystemNamesController do
  describe "#show" do
    context "with a bogus name" do
      let(:id) { "foo" }

      it "raises a 404" do
        expect {
          get :show, :id => id
        }.to raise_error
      end
    end

    context "with a user's name" do
      let(:user) { FactoryGirl.create(:user) }
      let(:id) { user.cached_system_name }

      it "redirects to the user's page" do
        get :show, :id => id
        response.should redirect_to(user_path(user))
      end
    end

    context "with a team's name" do
      let(:team) { FactoryGirl.create(:team) }
      let(:id) { team.system_name.name }

      it "redirects to the team's page" do
        get :show, :id => id
        response.should redirect_to(team_path(team))
      end
    end

    context "with a team name and jersey number" do
      let(:team) { FactoryGirl.create(:team, :with_players) }
      let(:player) { team.players.first }
      let(:jersey_number) { player.jersey_number }
      let(:id) { team.system_name.name }

      it "redirects to the player's page" do
        get :show, :id => id, :j => jersey_number
        response.should redirect_to(player_path(player))
      end
    end
  end
end
