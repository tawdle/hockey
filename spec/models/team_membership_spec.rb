require 'spec_helper'

describe TeamMembership do
  describe "#validations" do
    let(:creator) { FactoryGirl.create(:user) }
    let(:team_membership) { FactoryGirl.build(:team_membership, :creator => creator) }
    it "is valid" do
      team_membership.should be_valid
    end
    it "requires a team" do
      team_membership.team = nil
      team_membership.should_not be_valid
    end
    it "requires a member" do
      team_membership.member = nil
      team_membership.should_not be_valid
    end
    it "requires team/user combo to be unique" do
      team_membership.save!
      other_membership = FactoryGirl.build(:team_membership, :member => team_membership.member, :team => team_membership.team)
      other_membership.should_not be_valid
      other_membership = FactoryGirl.build(:team_membership, :member => team_membership.member)
      other_membership.should be_valid
      other_membership = FactoryGirl.build(:team_membership, :team => team_membership.team)
      other_membership.should be_valid
    end
    describe "#username_or_email" do
      before do
        team_membership.member = nil
      end
      context "with an invalid @username" do
        before { team_membership.username_or_email = "@foo" }
        it "rejects" do
          team_membership.should_not be_valid
        end
      end
      context "with a valid @username" do
        before { team_membership.username_or_email = FactoryGirl.create(:user).at_name }
        it "accepts" do
          team_membership.should be_valid
        end
      end
      context "with a new email address" do
        before { team_membership.username_or_email = "foo@foo.com" }
        it "accepts" do
          team_membership.should be_valid
        end
        it "creates a new user" do
          expect {
            team_membership.save!
          }.to change { User.count }.by(1)
        end
        it "sends an invitation" do
          expect {
            team_membership.save!
          }.to change { Invitation.count }.by(1)
        end
      end
      context "with a existing email address" do
        before { team_membership.username_or_email = FactoryGirl.create(:user).email }
        it "accepts" do
          team_membership.should be_valid
        end
        it "doesn't create a new user" do
          expect {
            team_membership.save!
          }.not_to change { User.count }
        end
      end
    end
  end
end
