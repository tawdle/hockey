require 'spec_helper'

describe Mention do
  describe "#validations" do
    let(:mention) { FactoryGirl.build(:mention) }
    it "creates a valid object" do
      mention.should be_valid
    end
    it "requires an activity_feed_item" do
      mention.activity_feed_item = nil
      mention.should_not be_valid
    end
    it "requires a system name" do
      mention.system_name = nil
      mention.should_not be_valid
    end
  end
end
