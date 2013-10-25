require 'spec_helper'

describe GameStaffMembersController do
  let(:game) { FactoryGirl.create(:game) }
  let(:staff_member) { FactoryGirl.create(:staff_member, :team => game.home_team) }
  let(:league) { game.home_team.league }
  let(:marker) { FactoryGirl.create(:authorization, :role => :marker, :authorizable => league).user }

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
      response.should redirect_to(game)
    end

    context "with an existing staff member" do
      before do
        game.staff_members << staff_member
      end
      let(:id) { game.game_staff_members.first.to_param }

      it "updates an existing staff member" do
        expect {
          do_request(staff_member.to_param => { :id => id, :selected => true, :staff_member_id => staff_member.to_param, :role => :coach })
        }.to change { game.reload.game_staff_members.first.role }.from(:assistant_coach).to(:coach)
      end

      it "removes an existing staff member" do
        expect {
          do_request(staff_member.to_param => { :id => id, :selected => false, :staff_member_id => staff_member.to_param })
        }.to change { game.reload.staff_members.count }.by(-1)
      end
    end
  end
end

