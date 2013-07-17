require 'spec_helper'

describe ActivityFeedItem do
  describe "#validations" do
    let(:activity_feed_item) { FactoryGirl.build(:activity_feed_item) }

    it "should create a valid object" do
      activity_feed_item.should be_valid
    end
    it "should require a message" do
      activity_feed_item.message = nil
      activity_feed_item.should_not be_valid
      activity_feed_item.message = ""
      activity_feed_item.should_not be_valid
    end
  end

  describe "#save" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    let(:activity_feed_item) { FactoryGirl.build(:activity_feed_item, :message => "@#{user1.name} just checked @#{user2.name} into the boards!") }

    it "should extract mentions" do
      expect {
        activity_feed_item.save!
      }.to change { Mention.count }.by(2)
      activity_feed_item.reload.mentions.count.should == 2
    end
  end
end
