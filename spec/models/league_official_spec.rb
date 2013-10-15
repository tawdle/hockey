require 'spec_helper'

describe LeagueOfficial do
  describe "#validations" do
    let(:league_official) { FactoryGirl.build(:league_official) }

    it "creates a valid object" do
      league_official.should be_valid
    end

    it "requires a league" do
      league_official.league = nil
      league_official.should_not be_valid
    end

    it "requires an official" do
      league_official.official = nil
      league_official.should_not be_valid
    end

    it "prevents duplicates" do
      other = FactoryGirl.create(:league_official, :league => league_official.league,
                                 :official => league_official.official)
      league_official.should_not be_valid
    end
  end
end
