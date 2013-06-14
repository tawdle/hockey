require 'spec_helper'

describe Team do
  describe "#validations" do
    before do
      @team = FactoryGirl.build(:team)
    end
    it "should generate a valid object" do
      @team.should be_valid
    end
    it "should require a name" do
      @team.name = ""
      @team.should_not be_valid
      @team.name = nil
      @team.should_not be_valid
    end
  end
end
