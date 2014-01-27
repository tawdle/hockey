require 'spec_helper'

describe Feed::UserPost do
  describe "#validations" do
    let(:user_post) { FactoryGirl.build(:feed_user_post) }

    it "should create a valid object" do
      user_post.should be_valid
    end
    it "should require a message" do
      user_post.message = nil
      user_post.should_not be_valid
    end
    it "should require a creator" do
      user_post.creator = nil
      user_post.should_not be_valid
    end
  end

  describe "#mentioned_objects" do
    let(:user) { FactoryGirl.create(:user) }
    let(:player) { FactoryGirl.create(:player) }
    let(:user_post) { FactoryGirl.build(:feed_user_post, :message => "OMG! #{user.at_name} just checked #{player.at_name} into the boards!") }

    it "should extract mentions" do
      reference = user_post
      expect {
        user_post.save!
      }.to change { user_post.mentions.count }.from(0).to(2)
      user_post.reload.mentions.count.should == 2
    end
  end
end
