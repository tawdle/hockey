require 'spec_helper'

describe User do
  describe "#validations" do
    let(:user) { FactoryGirl.build(:user) }
    it "should generate a valid object" do
      user.should be_valid
    end
    describe "#name" do
      it "should require a name" do
        user.name = ""
        user.should_not be_valid
        user.name = nil
        user.should_not be_valid
      end
      it "should require a unique name" do
        other_user = FactoryGirl.create(:user, :name => user.name)
        user.should_not be_valid
      end
      it "should prohibit invalid characters" do
        user.name = "foo*&^"
        user.should_not be_valid
      end
      it "should require at least 3 chars" do
        user.name = "ab"
        user.should_not be_valid
      end
      it "should require fewer than 20 chars" do
        user.name = "x" * 21
        user.should_not be_valid
      end
    end
    it "should prevent duplicate nameable references" do
      team = FactoryGirl.create(:team)
      user.nameable = team
      user.should_not be_valid
    end
  end
end

