require 'spec_helper'

describe TournamentsController do
  let(:tournament) { FactoryGirl.create(:tournament) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:manager) { FactoryGirl.create(:authorization, :role => :manager, :authorizable => tournament).user }

  describe "#index" do
    it "works" do
      tournament # create it
      get :index
      response.should render_template("index")
    end
  end

  describe "#show" do
    it "works" do
      get :show, :id => tournament.to_param
      response.body.should render_template("show")
    end
  end

  context "with a logged in admin" do
    before { sign_in(admin) }

    describe "#new" do
      it "works" do
        get :new
        response.body.should render_template("new")
      end
    end

    describe "#create" do
      it "works" do
        expect {
          post :create, :tournament => {:name => "My Tournament", :division => "bantam" }
          response.should be_redirect
        }.to change { Tournament.count }.by(1)
      end
    end
  end

  context "with a logged in manager" do

    before { sign_in(manager) }

    describe "#edit" do
      it "works" do
        get :edit, :id => tournament.to_param
      end
    end

    describe "#update" do
      it "works" do
        expect {
          put :update, :id => tournament.to_param, :tournament => {:division => :pee_wee }
          response.should redirect_to(tournament)
        }.to change { tournament.reload.division }.to(:pee_wee)
      end
    end
  end
end
