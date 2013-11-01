require 'spec_helper'

describe TournamentTeamsController do
  let(:tournament) { FactoryGirl.create(:tournament) }
  let(:manager) { FactoryGirl.create(:authorization, :role => :manager, :authorizable => tournament).user }
  let(:teams) { FactoryGirl.create_list(:team, 2) }

  context "with a signed in tournament manager" do
    before { sign_in(manager) }

    describe "#edit" do
      it "renders the edit template" do
        get :edit, :tournament_id => tournament.to_param
        response.body.should render_template("edit")
      end
    end
    describe "#update" do
      it "add teams" do
        expect {
          post :update, :tournament_id => tournament.to_param, :tournament => { :team_ids => teams.map(&:to_param) }
          response.should redirect_to(tournament)
        }.to change { tournament.reload.teams.count }.by(2)
      end
    end
  end

end
