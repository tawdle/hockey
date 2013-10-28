require 'spec_helper'

describe Location do
  describe "#validations" do
    let(:location) { FactoryGirl.build(:location) }

    it "creates a valid object" do
      location.should be_valid
    end

    it "requires a name" do
      location.name = nil
      location.should_not be_valid
    end

    it "requires a unique name" do
      FactoryGirl.create(:location, :name => location.name)
      location.should_not be_valid
    end

    it "requires an address" do
      location.address_1 = nil
      location.should_not be_valid
    end

    it "requires a city" do
      location.city = nil
      location.should_not be_valid
    end

    it "requires a state" do
      location.state = nil
      location.should_not be_valid
    end

    it "requires a zip" do
      location.zip = nil
      location.should_not be_valid
    end

    it "requires a country" do
      location.country = nil
      location.should_not be_valid
    end
  end
end
