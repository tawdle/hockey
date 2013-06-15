require 'spec_helper'

describe LeaguesController do
  describe "#index" do
    def do_request
      get :index
    end
    it "should work" do
      do_request
      response.should be_success
    end
  end
  describe "#show" do
    def do_request
      get :show, :id => @league.to_param
    end
    before do
      @league = FactoryGirl.create(:league)
    end
    it "should work" do
      do_request
      response.should be_success
    end
  end
  describe "#new" do
    def do_request
      get :new
    end
    it_behaves_like "a controller action requiring an authenticated admin"
  end
  describe "#edit" do
    def do_request
      get :edit, :id => @league.to_param
    end
    before do
      @league = FactoryGirl.create(:league)
    end
    it_behaves_like "a controller action requiring an authenticated admin"
  end
  describe "#create" do
    def do_request
      post :create, :league => {:name => "Test League" }
    end
    it_behaves_like "a controller action requiring an authenticated admin"
  end
  describe "#update" do
    def do_request
      put :update, :id => @league.to_param, :league => {:name => "New Test League" }
    end
    before do
      @league = FactoryGirl.create(:league)
    end
    it_behaves_like "a controller action requiring an authenticated admin"
  end
  describe "#destroy" do
    def do_request
      delete :destroy, :id => @league.to_param
    end
    before do
      @league = FactoryGirl.create(:league)
    end
    it_behaves_like "a controller action requiring an authenticated admin"
  end
end
