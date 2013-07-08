require 'spec_helper'

describe TeamsController do
  let(:team) { FactoryGirl.create(:team) }
  let(:league) { FactoryGirl.create(:league) }

  describe "#index" do
    def do_request
      get :index
    end
    it "should work" do
      do_request
    end
  end

  describe "#show" do
    def do_request
      get :show, :id => team.to_param
    end
    it "should work" do
      do_request
    end
  end

  describe "#new" do
    def do_request
      get :new, :league_id => league.to_param
    end
    it "should work" do
      do_request
    end
  end

  describe "#edit" do
    def do_request
      get :edit, :id => team.to_param
    end
    it "should work" do
      do_request
    end
  end

  describe "#create" do
    def do_request
      post :create, :team => {:name => "My New Team" }, :league_id => league.to_param
    end
    it "should work" do
      do_request
    end
  end

  describe "#update" do
    def do_request
      put :update, :id => team.to_param, :team => {:name => "My Very New Team" }
    end
    it "should work" do
      do_request
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy, :id => team.to_param
    end
    it "should work" do
      do_request
    end
  end
end
