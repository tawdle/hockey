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

    it "should require a system name" do
      following.system_name = nil
      following.should_not be_valid
    end

    it "should prevent duplicates" do
      other_following = FactoryGirl.create(:following, :user => following.user, :system_name => following.system_name)
      following.should_not be_valid
    end

    it "should prevent self-following" do
      following.system_name = following.user.system_name
      following.should_not be_valid
    end
  end
end
