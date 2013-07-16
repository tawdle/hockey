require 'spec_helper'

describe FollowingsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  context "when logged in" do
    before { sign_in(user) }

    describe "#create" do
      def do_request
        request.env["HTTP_REFERER"] = "/"
        post :create, :following => { :user_id => user.to_param, :target_id => other_user.to_param }
      end

      it "should create the following" do
        expect { 
          do_request
        }.to change { Following.count }.by(1)
      end
    end

    describe "#destroy" do
      let!(:following) { FactoryGirl.create(:following, :user => user) }

      def do_request
        request.env["HTTP_REFERER"] = "/"
        delete :destroy, :id => following.to_param
      end

      it "should destroy the referenced following" do
        expect {
          do_request
        }.to change { Following.count }.by(-1)
      end
    end
  end
end
