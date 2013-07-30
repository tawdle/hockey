require 'spec_helper'

describe TeamMembershipsController do
  let(:team) { FactoryGirl.create(:team) }
  let(:manager) { team.managers.first }
  let(:team_membership) { FactoryGirl.create(:team_membership, :team => team) }

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
        post :create, :team_id => team.to_param, :team_membership => { :username_or_email => "foo@foo.com" }.merge(args)
      end
      it "works" do
        do_request
        response.should be_redirect
      end
    end
    describe "#edit" do
      def do_request
        get :edit, :id => team_membership.to_param
      end

      it "works" do
        do_request
        response.should be_ok
      end
    end
    describe "#update" do
      def do_request
        put :update, :id => team_membership.to_param, :team_membership => { :jersey_number => "1234" }
      end

      it "works" do
        expect {
          do_request
          response.should be_redirect
        }.to change { team_membership.reload.jersey_number }.to("1234")
      end
    end
    describe "#destroy" do
      let!(:team_membership) { FactoryGirl.create(:team_membership, :team => team) }
      def do_request
        delete :destroy, :id => team_membership.to_param
      end
      it "works" do
        expect {
          do_request
        }.to change { TeamMembership.count }.by(-1)
        response.should be_redirect
      end
    end
  end
end
