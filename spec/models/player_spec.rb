require 'spec_helper'

describe Player do
  describe "#validations" do
    let(:creator) { FactoryGirl.create(:user) }
    let(:player) { FactoryGirl.build(:player, :creator => creator) }
    it "is valid" do
      player.should be_valid
    end
    it "requires a team" do
      player.team = nil
      player.should_not be_valid
    end
    it "requires a jersey number" do
      player.jersey_number = nil
      player.should_not be_valid
      player.jersey_number = ""
      player.should_not be_valid
    end
    context "with a user" do
      let(:player) { FactoryGirl.build(:player, :with_user) }
      it "requires team/user combo to be unique" do
        player.save!
        other_player = FactoryGirl.build(:player, :user => player.user, :team => player.team)
        other_player.should_not be_valid
        other_player = FactoryGirl.build(:player, :user => player.user)
        other_player.should be_valid
        other_player = FactoryGirl.build(:player, :team => player.team)
        other_player.should be_valid
      end
    end
    describe "#at_name" do
      context "without a user" do
        it "returns the team#jersey" do
          player.at_name.should match(player.team.name)
          player.at_name.should match(player.jersey_number.to_s)
        end
      end
      context "with a user" do
        let(:player) { FactoryGirl.build(:player, :with_user) }
        it "returns the user's @username" do
          player.at_name.should == player.user.at_name
        end
      end
    end
    describe "#username_or_email" do
      context "with an invalid @username" do
        before { player.username_or_email = "@foo" }
        it "rejects" do
          player.should_not be_valid
        end
      end
      context "with a valid @username" do
        before { player.username_or_email = FactoryGirl.create(:user).at_name }
        it "accepts" do
          player.should be_valid
        end
      end
      context "with a new email address" do
        before { player.username_or_email = "foo@foo.com" }
        it "accepts" do
          player.should be_valid
        end
        it "sends an invitation" do
          Invitation.should_receive(:create!)
          player.save!
        end
      end
      context "with a existing email address" do
        before { player.username_or_email = FactoryGirl.create(:user).email }
        it "accepts" do
          player.should be_valid
        end
        it "doesn't create a new user" do
          expect {
            player.save!
          }.not_to change { User.count }
        end
      end
    end
  end
end
