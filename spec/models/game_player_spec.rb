require 'spec_helper'

describe GamePlayer do
  let(:game_player) { FactoryGirl.build(:game_player) }
  describe "#validations" do
    it "produces a valid object" do
      game_player.should be_valid
    end
    it "requires a game" do
      game_player.game = nil
      game_player.should_not be_valid
    end
    it "requires a player" do
      game_player.player = nil
      game_player.should_not be_valid
    end
    it "prevents duplicates" do
      other_game_player = FactoryGirl.create(:game_player, :game => game_player.game, :player => game_player.player)
      game_player.should_not be_valid
    end
    it "requires that the player be on one of the two teams in the game" do
      game_player.player = FactoryGirl.build(:player)
      game_player.should_not be_valid
    end
  end
end
