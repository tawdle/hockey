require 'spec_helper'

describe ActivityFeedItem do
  describe "#validations" do
    let(:activity_feed_item) { FactoryGirl.build(:activity_feed_item) }

    it "should create a valid object" do
      activity_feed_item.should be_valid
    end
  end
end
