require 'spec_helper'

describe GamesController do
  let(:league) { FactoryGirl.create(:league, :with_manager, :with_marker, :with_team) }
  let(:manager) { league.managers.first }
  let(:team) { league.teams.first }
  let(:game) { FactoryGirl.create(:game, :league => league, :home_team => team) }
  let(:marker) { league.markers.first }

  before do
    request.env["HTTP_REFERER"] = "/"
  end

  describe "#show" do
    def do_request
      get :show, :id => game.to_param
    end

    it "should work" do
      do_request
      response.should be_ok
    end
  end
end
