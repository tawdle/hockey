require 'spec_helper'

describe GameOfficial do
  describe "#validations" do
    let(:game_official) { FactoryGirl.build(:game_official) }

    it "creates a valid object" do
      game_official.should be_valid
    end

    it "requires a game" do
      game_official.game = nil
      game_official.should_not be_valid
    end

    it "requires an official" do
      game_official.official = nil
      game_official.should_not be_valid
    end

    it "requires a role" do
      game_official.role = nil
      game_official.should_not be_valid
    end

    it "prevents duplicates" do
      other = FactoryGirl.create(:game_official, :game => game_official.game, :official => game_official.official)
      game_official.should_not be_valid
    end
  end
end
