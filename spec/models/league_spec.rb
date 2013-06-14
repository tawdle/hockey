require 'spec_helper'

describe League do
  describe "#validations" do
    before do
      @league = FactoryGirl.build(:league)
    end
    it "generates a valid object" do
      FactoryGirl.build(:league).should be_valid
    end
    it "requires a name" do
      @league.name = ""
      @league.should_not be_valid
      @league.name = nil
      @league.should_not be_valid
    end
  end
end
