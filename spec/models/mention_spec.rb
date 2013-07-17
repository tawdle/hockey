require 'spec_helper'

describe Mention do
  describe "#validations" do
    let(:mention) { FactoryGirl.build(:mention) }
    it "should create a valid object" do
      mention.should be_valid
    end
    it "should require an activity_feed_item" do
      mention.activity_feed_item = nil
      mention.should_not be_valid
    end
    it "should require a user" do
      mention.user = nil
      mention.should_not be_valid
    end
  end
end
