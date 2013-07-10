require 'spec_helper'

describe ActivityFeedItem do
  describe "#validations" do
    let(:activity_feed_item) { FactoryGirl.build(:activity_feed_item) }

    it "should create a valid object" do
      activity_feed_item.should be_valid
    end
    it "should require a target" do
      activity_feed_item.target = nil
      activity_feed_item.should_not be_valid
    end
    it "should require a message" do
      activity_feed_item.message = nil
      activity_feed_item.should_not be_valid
      activity_feed_item.message = ""
      activity_feed_item.should_not be_valid
    end

  end
end
