require 'spec_helper'

describe Official do
  describe "#validations" do
    let(:official) { FactoryGirl.build(:official) }

    it "creates a valid object" do
      official.should be_valid
    end

    it "requires a name" do
      official.name = nil
      official.should_not be_valid
    end

    it "prohibits duplicate names within a league" do
      other_official = FactoryGirl.create(:official, :name => official.name, :league => official.league)
      official.should_not be_valid
    end

    it "requires a league" do
      official.league = nil
      official.should_not be_valid
    end
  end
  it_behaves_like "a model that implements soft delete"
end
