require 'spec_helper'

describe Game do
  describe "#validations" do
    let(:game) { FactoryGirl.build(:game) }

    it "should create a valid object" do
      game.should be_valid
    end

    it "should require a valid status" do
      game.status = :foo
      game.should_not be_valid
    end

    it "should require a home team" do
      game.home_team = nil
      game.should_not be_valid
    end

    it "should require a visiting team" do
      game.visiting_team = nil
      game.should_not be_valid
    end

    it "should require different home and visiting teams" do
      game.visiting_team = game.home_team
      game.should_not be_valid
    end

    it "should require a location" do
      game.location = nil
      game.should_not be_valid
    end

    it "should require a start" do
      game.start = nil
      game.should_not be_valid
    end

    it "should require the start be in the future" do
      game.start = 1.week.ago
      game.should_not be_valid
    end
  end
end
