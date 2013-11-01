require 'spec_helper'

describe Leagues::OfficialsController do
  let(:official) { FactoryGirl.create(:official) }
  let(:league) { official.leagues.first }
  let(:manager) { FactoryGirl.create(:authorization, :authorizable => league, :role => :manager).user }

  describe "#show" do
    def do_request
      get :show, :league_id => league.to_param, :id => official.to_param
    end

    it "works" do
      do_request
      response.should be_success
      response.should render_template("show")
    end
  end

  context "with signed in league manager" do
    before do
      sign_in(manager)
    end

    describe "#new" do
      def do_request
        get :new, :league_id => league.to_param
      end

      it "works" do
        do_request
        response.should be_success
        response.should render_template("new")
      end
    end

    describe "#create" do
      def do_request
        post :create, :league_id => league.to_param, :official => { :name => "Ricky Ref" }
      end
      it "creates the official" do
        expect {
          do_request
          response.should redirect_to(league)
        }.to change { league.reload.officials.count }.by(1)
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :league_id => league.to_param, :id => official.to_param
      end
      it "works" do
        do_request
        response.should be_success
        response.should render_template("edit")
      end
    end

    describe "#update" do
      def do_request
        put :update, :league_id => league.to_param, :id => official.to_param, :official => { :name => "New Name" }
      end
      it "updates the official" do
        expect {
          do_request
          response.should redirect_to(league)
        }.to change { official.reload.name }.to("New Name")
      end
    end
    describe "#destroy" do
      def do_request
        delete :destroy, :league_id => league.to_param, :id => official.to_param
      end
      it "removes the official from the league" do
        official.reload # Make sure it exists
        expect {
          do_request
          response.should redirect_to(league)
        }.to change { league.officials.count }.by(-1)
      end
    end
  end
end
