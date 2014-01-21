require 'spec_helper'

describe Players::ClaimsController do
  context "with a logged in user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:player) { FactoryGirl.create(:player) }

    before do
      sign_in(user)
    end

    describe "#new" do
      def do_request
        get :new, :player_id => player.to_param
      end

      it "renders the form" do
        do_request
        response.should render_template("new")
      end
    end

    describe "#create" do
      def do_request
        post :create, :player_id => player.to_param, :claim => {:kiosk_password => "foofoo" }
      end

      before do
        Player.any_instance.stub(:kiosk_password).and_return(true)
      end

      it "sets the current user as the player's owner" do
        expect {
          do_request
        }.to change { player.reload.user_id }.to(user.id)
      end
    end

  end
end
