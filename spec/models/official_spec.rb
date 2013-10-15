require 'spec_helper'

describe Official do
  describe "#validations" do
    let(:official) { FactoryGirl.create(:official) }

    it "creates a valid object" do
      official.should be_valid
    end

    it "requires a name" do
      official.name = nil
      official.should_not be_valid
    end

    it "requires at least one league" do
      official.leagues = []
      official.should_not be_valid
    end
  end
end
