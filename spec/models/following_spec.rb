require 'spec_helper'

describe Following do
  describe "#validations" do
    let(:following) { FactoryGirl.build(:following) }

    it "should create a valid object" do
      following.should be_valid
    end

    it "should require a user" do
      following.user = nil
      following.should_not be_valid
    end

    it "should require a target" do
      following.target = nil
      following.should_not be_valid
    end

    it "should prevent duplicates" do
      other_following = FactoryGirl.create(:following, :user => following.user, :target => following.target)
      following.should_not be_valid
    end

    it "should prevent self-following" do
      following.target = following.user
      following.should_not be_valid
    end
  end
end
