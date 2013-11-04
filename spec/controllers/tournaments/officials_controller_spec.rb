require 'spec_helper'

describe Tournaments::OfficialsController do
  let(:tournament) { FactoryGirl.create(:tournament) }
  let(:official) { FactoryGirl.create(:official, :league => tournament) }
  let(:manager) { FactoryGirl.create(:authorization, :authorizable => tournament, :role => :manager).user }

  describe "#show" do
    def do_request
      get :show, :tournament_id => tournament.to_param, :id => official.to_param
    end

    it "works" do
      do_request
      response.should be_success
      response.should render_template("show")
    end
  end

  context "with signed in tournament manager" do
    before do
      sign_in(manager)
    end

    describe "#new" do
      def do_request
        get :new, :tournament_id => tournament.to_param
      end

      it "works" do
        do_request
        response.should be_success
        response.should render_template("new")
      end
    end

    describe "#create" do
      def do_request
        post :create, :tournament_id => tournament.to_param, :official => { :name => "Ricky Ref" }
      end
      it "creates the official" do
        expect {
          do_request
          response.should redirect_to(tournament)
        }.to change { tournament.reload.officials.count }.by(1)
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :tournament_id => tournament.to_param, :id => official.to_param
      end
      it "works" do
        do_request
        response.should be_success
        response.should render_template("edit")
      end
    end

    describe "#update" do
      def do_request
        put :update, :tournament_id => tournament.to_param, :id => official.to_param, :official => { :name => "New Name" }
      end
      it "updates the official" do
        expect {
          do_request
          response.should redirect_to(tournament)
        }.to change { official.reload.name }.to("New Name")
      end
    end
    describe "#destroy" do
      def do_request
        delete :destroy, :tournament_id => tournament.to_param, :id => official.to_param
      end
      it "removes the official from the tournament" do
        official.reload # Make sure it exists
        expect {
          do_request
          response.should redirect_to(tournament)
        }.to change { tournament.officials.count }.by(-1)
      end
    end
  end
end
