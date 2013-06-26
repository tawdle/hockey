require 'spec_helper'

describe Authorization do
  describe "#validations" do
    context "with a global role" do
      before do
        @authorization = FactoryGirl.build(:authorization)
      end
      it "should create a valid object" do
        @authorization.should be_valid
      end
      it "should require a user" do
        @authorization.user = nil
        @authorization.should_not be_valid
      end
      it "should require a role" do
        @authorization.role = nil
        @authorization.should_not be_valid
      end
      it "should prevent duplicates" do
        FactoryGirl.create(:authorization, :user => @authorization.user, :role => @authorization.role)
        @authorization.should_not be_valid
      end
    end
    context "with a scoped role" do
      before do
        @authorization = FactoryGirl.build(:authorization, :with_authorizable)
      end
      it "should be valid" do
        @authorization.should be_valid
      end
      it "should require an authorizable" do
        @authorization.authorizable = nil
        @authorization.should_not be_valid
      end
      it "should prevent duplicates" do
        FactoryGirl.create(:authorization, :user => @authorization.user, :role => @authorization.role, :authorizable => @authorization.authorizable)
        @authorization.should_not be_valid
      end
    end
  end
end
