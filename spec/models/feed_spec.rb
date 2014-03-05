require 'spec_helper'

shared_examples "a feed item with a game" do
  describe "#validations" do
    it "requires a game" do
      item.game = nil
      item.should_not be_valid
    end
  end
  describe "#message" do
    it { item.message.should include(item.game.home_team.at_name) }
    it { item.message.should include(item.game.visiting_team.at_name) }
  end
end

shared_examples "a feed item with a user" do
  describe "#validations" do
    it "requires a user" do
      item.user = nil
      item.should_not be_valid
    end
  end
  describe "#message" do
    it { item.message.should include(item.user.at_name) }
  end
end

shared_examples "a feed item with a player" do
  describe "#validations" do
    it "requires a player" do
      item.player = nil
      item.should_not be_valid
    end
  end
  describe "#message" do
    it { item.message.should include(item.player.at_name) }
  end
end

shared_examples "a feed item with a league" do
  describe "#validations" do
    it "requires a league" do
      item.league = nil
      item.should_not be_valid
    end
  end
  describe "#message" do
    it { item.message.should include(item.league.at_name) }
  end
end

shared_examples "a feed item with a user and a game" do
  describe "#validations" do
    it_behaves_like "a feed item with a game"
    it_behaves_like "a feed item with a user"
  end
end

shared_examples "a feed item with a user and a league" do
  describe "#validations" do
    it_behaves_like "a feed item with a user"
    it_behaves_like "a feed item with a league"
  end
end

module Feed
  describe UserPost do
    let(:item) { FactoryGirl.build(:user_post) }
    it { item.should be_valid }
  end

  describe CancelGame do
    let(:item) { FactoryGirl.build(:cancel_game) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user and a game"
    it "generates a message" do
      item.message.should include 'canceled a game'
    end
  end

  describe CancelGoal do
    let(:item) { FactoryGirl.build(:cancel_goal) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user"
    describe "#validations" do
      it "requires a game" do
        item.game = nil
        item.should_not be_valid
      end
      it "requires a player" do
        item.player = nil
        item.should_not be_valid
      end
      it "generates a message" do
        item.message.should include 'canceled'
      end
    end
  end
  describe ChangeGameLocation do
    let(:item) { FactoryGirl.build(:change_game_location) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user and a game"
    it "generates a message" do
      item.message.should include 'changed the location'
    end
  end

  describe ChangeGameTime do
    let(:item) { FactoryGirl.build(:change_game_time) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user and a game"
    it "generates a message" do
      item.message.should include 'changed the start time'
    end
  end

  describe GameEnded do
    let(:item) { FactoryGirl.build(:game_ended) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a game"
    it "generates a message" do
      item.message.should include 'Game over'
    end
  end

  describe NewFollowing do
    let(:item) { FactoryGirl.build(:new_following) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user"
    it "generates a message" do
      item.message.should include "is now following"
      item.message.should include item.user.at_name
      item.message.should include item.target.at_name
    end
  end
  describe NewGame do
    let(:item) { FactoryGirl.build(:new_game) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user and a game"
    it "generates a message" do
      item.message.should include 'scheduled a game between'
    end
  end

  describe NewGoal do
    let(:item) { FactoryGirl.build(:new_goal) }
    it { item.should be_valid }
    describe "#validations" do
      it "requires a game" do
        item.game = nil
        item.should_not be_valid
      end
      it "requires a player" do
        item.player = nil
        item.should_not be_valid
      end
    end
    it "generates a message" do
      item.message.should include 'scored a goal'
    end
  end

  describe NewGoalie do
    let(:item) { FactoryGirl.build(:new_goalie) }
    it { item.should be_valid }
    describe "#validatons" do
      it "requires a player" do
        item.player = nil
        item.should_not be_valid
      end
    end
    it "generates a message" do
      item.message.should include 'is in the net'
    end
  end

  describe NewLeagueManager do
    let(:item) { FactoryGirl.build(:new_league_manager) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user and a league"
    it { item.message.should include 'became a manager' }
  end

  describe NewPenalty do
    let(:item) { FactoryGirl.build(:new_penalty) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a player"
    it { item.message.should include "received a penalty" }
  end

  describe NewPlayerClaim do
    let(:item) { FactoryGirl.build(:new_player_claim) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user"
    it_behaves_like "a feed item with a player"
  end

  describe NewUser do
    let(:item) { FactoryGirl.build(:new_user) }
    it { item.should be_valid }
    it_behaves_like "a feed item with a user"
    it { item.message.should include 'became a BigShot' }
  end
end
