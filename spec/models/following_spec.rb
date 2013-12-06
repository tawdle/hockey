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

    it "should require a followable" do
      following.followable = nil
      following.should_not be_valid
    end

    it "should prevent duplicates" do
      team = FactoryGirl.create(:team)
      following = FactoryGirl.build(:following, :followable => team)
      other_following = FactoryGirl.create(:following, :user => following.user, :followable => team)
      following.should_not be_valid
    end

    it "should prevent self-following" do
      following.followable = following.user
      following.should_not be_valid
    end
  end
end
