require 'spec_helper'

describe PlayersController do
  let(:team) { FactoryGirl.create(:team) }
  let(:manager) { team.managers.first }
  let(:player) { FactoryGirl.create(:player, :team => team) }

  context "with a logged in team manager" do
    before { sign_in(manager) }

    describe "#index"
    describe "#new" do
      def do_request
        get :new, :team_id => team.to_param
      end
      it "works" do
        do_request
        response.should be_ok
      end
    end
    describe "#create" do
      def do_request(args = {})
        post :create, :team_id => team.to_param, :player => { :username_or_email => "foo@foo.com", :name => "John Smith", :jersey_number => "12" }.merge(args)
      end
      it "works" do
        do_request
        response.should be_redirect
      end
    end
    describe "#edit" do
      def do_request
        get :edit, :id => player.to_param
      end

      it "works" do
        do_request
        response.should be_ok
      end
    end
    describe "#update" do
      def do_request
        put :update, :id => player.to_param, :player => { :jersey_number => "1234" }
      end

      it "works" do
        expect {
          do_request
          response.should be_redirect
        }.to change { player.reload.jersey_number }.to("1234")
      end
    end
    describe "#destroy" do
      let!(:player) { FactoryGirl.create(:player, :team => team) }
      def do_request
        delete :destroy, :id => player.to_param
      end
      it "works" do
        expect {
          do_request
        }.to change { Player.count }.by(-1)
        response.should be_redirect
      end
    end
  end
end
