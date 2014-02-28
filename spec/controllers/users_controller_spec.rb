# encoding: utf-8

require 'spec_helper'

describe UsersController do
  context "without a signed in user" do
    describe "#email_available" do
      let(:user) { FactoryGirl.create(:user) }

      def do_request(email)
        post :email_available, :format => :json, :user => {:email => email }
      end

      context "with an already existing address" do
        let(:email) { "  #{user.email.upcase}  " }
        it "returns false" do
          do_request(email)
          response.body.should == "false"
        end
      end

      context "with a new address" do
        let(:email) { "foofoofoo@foo.com" }
        it "returns true" do
          do_request(email)
          response.body.should == "true"
        end
      end
    end

    describe "#system_name_available" do
      let!(:system_name) { FactoryGirl.create(:system_name, :name => "Éric") }

      def do_request(name)
        post :system_name_available, :format => :json, :user => {:system_name_attributes => { :name => name } }
      end

      context "with an already existing name" do
        let(:name) { "  eric " }
        it "returns false" do
          do_request(name)
          response.body.should == "false"
        end
      end
      context "with a new name" do
        let(:name) { "Érica" }
        it "returns true" do
          do_request(name)
          response.body.should == "true"
        end
      end
    end
  end

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
