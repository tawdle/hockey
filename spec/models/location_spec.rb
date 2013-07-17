require 'spec_helper'

describe Location do
  describe "#validations" do
    let(:location) { FactoryGirl.build(:location) }

    it "should create a valid object" do
      location.should be_valid
    end

    it "should require a name" do
      location.name = nil
      location.should_not be_valid
    end

    it "should require a unique name" do
      FactoryGirl.create(:location, :name => location.name)
      location.should_not be_valid
    end
  end
end
