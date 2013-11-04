require 'spec_helper'

describe GameGoalie do
  describe "#validations" do
    let(:game_goalie) { FactoryGirl.build(:game_goalie) }
    let(:game) { game_goalie.game }

    it "creates a valid object" do
      game_goalie.should be_valid
    end

    it "requires a game" do
      game_goalie.game = nil
      game_goalie.should_not be_valid
    end

    it "requires a goalie" do
      game_goalie.goalie = nil
      game_goalie.should_not be_valid
    end

    it "sets the start_time and start_period" do
      expect {
        expect {
          game_goalie.valid?
        }.to change { game_goalie.start_time }.from(nil).to(0)
      }.to change { game_goalie.start_period }.from(nil).to(0)
    end

    it "caps the previous one when creating a new one" do
      previous_game_goalie = FactoryGirl.create(:game_goalie, :game => game)
      expect {
        game_goalie.save!
      }.to change { previous_game_goalie.reload.end_time }.from(nil)
    end
  end
end
