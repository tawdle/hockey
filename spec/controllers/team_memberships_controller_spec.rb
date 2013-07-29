require 'spec_helper'

describe TeamMembershipsController do
  let(:team) { FactoryGirl.create(:team) }
  let(:manager) { team.managers.first }

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
    describe "#destroy" do
      let!(:team_membership) { FactoryGirl.create(:team_membership, :team => team) }
      def do_request
        delete :destroy, :team_id => team.to_param, :id => team_membership.to_param
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
