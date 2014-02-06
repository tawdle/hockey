require 'spec_helper'

describe Players::ClaimsController do
  context "with a logged in user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:player) { FactoryGirl.create(:player) }

    describe "approve/deny side" do
      let(:player_claim) { FactoryGirl.create(:player_claim,  :player => player, :creator => user) }
      let(:manager) { player_claim.player.team.managers.first }

      before do
        sign_in(manager)
      end

      describe "#show" do
        def do_request
          get :show, :player_id => player.to_param, :id => player_claim.to_param
        end

        it "renders the #show template" do
          do_request
          response.should be_ok
          response.should render_template("players/claims/show")
        end
      end

      describe "#approve" do
        def do_request
          post :approve, :player_id => player.to_param, :id => player_claim.to_param
        end

        it "redirects to the team page" do
          do_request
          response.should redirect_to(player.team)
        end
      end

      describe "#deny" do
        def do_request
          post :deny, :player_id => player.to_param, :id => player_claim.to_param
        end

        it "redirects to the team page" do
          do_request
          response.should redirect_to(player.team)
        end
      end
    end

    describe "claim side" do
      def enable_kiosk_mode
        Kiosk.any_instance.stub(:valid?).and_return(true)
        Kiosk.stub(:password_matches).and_return(true)
      end

      before do
        sign_in(user)
      end

      describe "#new" do
        def do_request
          get :new, :player_id => player.to_param
        end

        context "in kiosk mode" do
          before { enable_kiosk_mode }

          it "renders the form" do
            do_request
            response.should be_ok
            response.should render_template("new")
          end
        end

        context "in normal mode" do
          it "renders the form" do
            do_request
            response.should be_ok
            response.should render_template("new")
          end
        end
      end

      describe "#create" do
        def do_request
          post :create, :player_id => player.to_param, :claim => {:kiosk_password => "foofoo" }
        end

        context "in kiosk mode" do
          before { enable_kiosk_mode }

          it "sets the current user as the player's owner" do
            expect {
              do_request
            }.to change { player.reload.user_id }.to(user.id)
          end
        end

        context "in normal mode" do
          it "creates a player_claim" do
            expect {
              do_request
              response.should redirect_to(player)
            }.to change { player.reload.claims.count }.by(1)
          end
        end
      end
    end
  end
end
