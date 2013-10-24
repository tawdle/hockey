require 'spec_helper'

describe StaffMembersController do
  let(:team) { FactoryGirl.create(:team, :with_staff) }
  let(:staff_member) { team.staff_members.first }
  let(:manager) { team.managers.first }
  context "with a logged in team manager" do
    before { sign_in(manager) }
    describe "#index" do
      def do_request
        get :index, :team_id => team.to_param
      end
      it "works" do
        do_request
        response.should be_success
        response.should render_template('index')
      end
    end
    describe "#new" do
      def do_request
        get :new, :team_id => team.to_param
      end
      it "renders the new template" do
        do_request
        response.should render_template("new")
      end
    end
    describe "#create" do
      def do_request
        post :create, :team_id => team.to_param, :staff_member => {:name => "Heny Mancini" }
      end
      it "creates a new staff member" do
        expect {
          do_request
        }.to change { team.staff_members.count }.by(1)
      end
      it "redirects back to the team's staff members page" do
        do_request
        response.should redirect_to team_staff_members_path(team)
      end
    end
    describe "#edit" do
      def do_request
        get :edit, :team_id => team.to_param, :id => staff_member.to_param
      end
      it "should render the edit template" do
        do_request
        response.should render_template("edit")
      end
    end
    describe "#update" do
      def do_request
        put :update, :team_id => team.to_param, :id => staff_member.to_param, :staff_member => {:name => "Thurgood Marshall" }
      end
      it "should update the name" do
        do_request
        staff_member.reload.name.should == "Thurgood Marshall"
      end
      it "redirect to the team's staff members page" do
        do_request
        response.should redirect_to team_staff_members_path(team)
      end
    end
  end
end
