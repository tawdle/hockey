require 'spec_helper'

describe InvitationsController do
  let(:target) { FactoryGirl.create(:league, :with_manager) }
  let(:manager) { target.managers.first }
  let(:invitation) { FactoryGirl.create(:invitation) }
  let(:invited_user) { FactoryGirl.create(:user, :email => invitation.email) }

  describe "#new" do
    def do_request
      get :new, :predicate => :manage, :target_type => target.class.to_s, :target_id => target.to_param
    end

    it "should work" do
      sign_in(manager)
      do_request
      response.should be_success
      response.should render_template :new
    end
  end

  describe "#create" do
    def do_request
      post :create, :invitation => {:email => "foo@test.com", :predicate => :manage, :target_type => target.class.to_s, :target_id => target.to_param }
    end
    it "should work" do
      sign_in(manager)
      expect {
        do_request
      }.to change { Invitation.count }.by(1)

      response.should be_redirect
      flash[:notice].should =~ /Your invitation to .* has been sent/
      response.should_not render_template :new
    end
  end

  describe "#accept" do
    def do_request
      get :accept, :id => invitation.to_param
    end
    it "should work" do
      sign_in(invited_user)
      expect {
        do_request
      }.to change { invitation.reload.state }.from(:pending).to(:accepted)
      response.should be_success
    end
  end

  describe "#decline" do
    def do_request
      get :decline, :id => invitation.to_param
    end
    it "should work" do
      sign_in(invited_user)
      expect {
        do_request
      }.to change { invitation.reload.state }.from(:pending).to(:declined)
      response.should be_redirect
    end
  end
end
