require 'spec_helper'

describe Marker::GameStaffMembersController do
  let(:game) { FactoryGirl.create(:game) }
  let(:staff_member) { FactoryGirl.create(:staff_member, :team => game.home_team) }
  let(:league) { game.home_team.league }
  let(:marker) { FactoryGirl.create(:authorization, :role => :marker, :authorizable => league).user }

  context "with a logged in marker" do
    before { sign_in(marker) }

    describe "#new" do
      def do_request
        get :new, :game_id => game.to_param, :home_or_visiting => :home
      end

      it "renders the new form" do
        do_request
        response.should render_template("new")
      end
    end

    describe "#create" do
      def do_request
        post :create, :game_id => game.to_param, :home_or_visiting => :home, :staff_member => { :name => "Ronald McDonald", :role => :safety_attendant }
      end

      it "creates a new staff member for the team" do
        expect {
          do_request
        }.to change { game.reload.home_team.staff_members.count }.by(1)
      end

      it "adds the new staff member to the game" do
        expect {
          do_request
        }.to change { game.reload.staff_members.count }.by(1)
      end

      it "sets the new staff member's role properly in the game and on the team" do
        do_request
        staff_member = StaffMember.find_by_name("Ronald McDonald")
        staff_member.should_not be_nil
        staff_member.role.should == :safety_attendant
        game_staff_member = GameStaffMember.find_by_staff_member_id(staff_member.id)
        game_staff_member.should_not be_nil
        game_staff_member.role.should == :safety_attendant
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :game_id => game.to_param, :home_or_visiting => :home
      end

      it "renders the edit form" do
        do_request
        response.should render_template("edit")
      end
    end

    describe "#update" do
      def do_request(attrs={})
        post :update, :game_id => game.to_param, :home_or_visting => :home,
          :game => {:game_staff_members_attributes =>  attrs }
      end

      it "adds a staff member to the game" do
        expect {
          do_request(staff_member.to_param => { :selected => true, :staff_member_id => staff_member.to_param })
        }.to change { game.staff_members.count }.by(1)
      end


      it "redirects back to the game" do
        do_request
        response.should redirect_to marker_game_path(game)
      end

      context "with an existing staff member" do
        before do
          game.staff_members << staff_member
        end
        let(:id) { game.game_staff_members.first.to_param }

        it "updates an existing staff member" do
          expect {
            do_request(staff_member.to_param => { :id => id, :selected => true, :staff_member_id => staff_member.to_param, :role => :head_coach })
          }.to change { game.reload.game_staff_members.first.role }.from(:assistant_coach).to(:head_coach)
        end

        it "removes an existing staff member" do
          expect {
            do_request(staff_member.to_param => { :id => id, :selected => false, :staff_member_id => staff_member.to_param })
          }.to change { game.reload.staff_members.count }.by(-1)
        end
      end
    end
  end
end

