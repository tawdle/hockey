require 'spec_helper'

describe UsersController do
  context "with a signed in user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before { sign_in(user) }

    describe "#show" do
      def do_request(user=user)
        get :show, :id => user.to_param
      end

      it "renders the user's own profile" do
        do_request
        response.should be_success
        response.should render_template("show")
      end

      it "renders another user's profile" do
        do_request(other_user)
        response.should be_success
        response.should render_template("show")
      end
    end
    describe "#edit" do
      def do_request
        get :edit, :id => user.to_param
      end

      it "renders the user's edit page" do
        do_request
        response.should be_success
        response.should render_template("edit")
      end
    end
    describe "#update" do
      def do_request
        put :update, :id => user.to_param, :user => { :email => "foobar2@example.com" }
      end

      it "should update the user's attributes" do
        expect {
          do_request
        }.to change { user.reload.email }.to("foobar2@example.com")
      end
      it "should redirect back to the user's profile" do
        do_request
        response.should redirect_to(user)
      end
    end
  end

  context "with a logged in admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:other_user) { FactoryGirl.create(:user) }

    before { sign_in(admin) }

    describe "#impersonate" do
      def do_request
        get :impersonate, :id => other_user.to_param
      end
      it "should switch logged in users" do
        controller.should_receive(:sign_in).with(other_user)
        do_request
      end
    end
  end
end
