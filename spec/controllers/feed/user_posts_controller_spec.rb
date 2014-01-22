require 'spec_helper'

describe Feed::UserPostsController do
  context "with a logged in user" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in(user)
    end
    describe "#create" do
      def do_request
        post :create, :user_post => { :message => "Hi folks!" }
      end
    end
  end

end
