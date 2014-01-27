require 'spec_helper'

describe Marker::GamePlayersController do
  let(:game) { FactoryGirl.create(:game) }
  let(:player) { FactoryGirl.create(:player, :team => game.home_team) }

  describe "#new" do
    def do_request
      get :new, :game_id => game.to_param
    end

    it "works" do
      do_request
      response.should be_ok
      response.should render_template('new')
    end
  end

  describe "#create" do
    def do_request
      post :create, :game_id => game.to_param, :player => { :jersey_number => "17", :name => "John Smith", :role => :player }
    end
    it "creates a new player" do
      expect {
        do_request
      }.to change { Player.count }.by(1)
    end

    it "adds the player to the game" do
      expect {
        do_request
      }.to change { game.players.count }.by(1)
    end
  end

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
