require 'spec_helper'

describe Leagues::TeamsController do
  let(:league) { FactoryGirl.create(:league, :with_manager) }
  let(:team) { FactoryGirl.create(:team, :league => league) }
  let(:manager) { league.managers.first }

  describe "#index" do
    def do_request
      get :index
    end
    it "should work" do
      do_request
      response.should be_ok
      response.should render_template("index")
    end
  end

  describe "#show" do
    def do_request
      get :show, :id => team.to_param
    end
    it "should work" do
      do_request
      response.should be_ok
      response.should render_template("show")
    end
  end

  context "with a signed in league manager" do
    before { sign_in(manager) }

    describe "#new" do
      def do_request
        get :new, :league_id => league.to_param
      end
      it "should work" do
        do_request
        response.should be_ok
        response.should render_template("new")
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :id => team.to_param
      end
      it "should work" do
        do_request
        response.should be_ok
        response.should render_template("edit")
      end
    end

    describe "#create" do
      def do_request
        post :create, :team => {:name => "My New Team", :system_name_attributes => {:name => "MyNewTeam" } }, :league_id => league.to_param
      end

      it "should work" do
        expect { do_request }.to change { Team.count }.by(1)
      end
    end

    describe "#update" do
      def do_request
        put :update, :id => team.to_param, :team => {:name => "My Very New Team" }
      end
      it "should work" do
        expect { do_request }.to change { team.reload.name }.to("My Very New Team")
      end
    end
  end

  context "with a logged in admin" do

    before { sign_in_as_admin }

    describe "#destroy" do
      def do_request
        delete :destroy, :id => team.to_param
      end
      it "should work" do
        do_request
      end
    end
  end
end
