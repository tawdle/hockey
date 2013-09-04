require 'spec_helper'

describe GamePlayersController do
  let(:game) { FactoryGirl.create(:game) }
  let(:player) { FactoryGirl.create(:player, :team => game.home_team) }

  describe "#edit" do
    def do_request
      get :edit, :game_id => game.to_param
    end

    it "works" do
      do_request
      response.should be_ok
      response.should render_template('edit')
    end

  end

  describe "#update" do
    def do_request
      put :update, :game_id => game.to_param, :game => { :player_ids => [player.id] }
    end

    it "adds the player" do
      expect {
        do_request
        response.should be_redirect
      }.to change { game.reload.players.include?(player) }.from(false).to(true) 
    end
  end
end
