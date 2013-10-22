require 'spec_helper'

describe Team do
  describe "#validations" do
    let(:team) { FactoryGirl.build(:team) }
    it "should generate a valid object" do
      team.should be_valid
    end
    it "should require a full_name" do
      team.full_name = ""
      team.should_not be_valid
      team.full_name = nil
      team.should_not be_valid
    end
    it "should require a league" do
      team.league = nil
      team.should_not be_valid
    end
    it "should require a user" do
      team.user = nil
      team.should_not be_valid
    end
  end

  describe "#name" do
    let(:team) { FactoryGirl.build(:team) }

    it "should delegate to the user object" do
      team.name.should == team.user.name
    end
  end

  describe "#accepted_invitation_to_join" do
    let(:team) { FactoryGirl.create(:team) }
    let(:user) { FactoryGirl.create(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :user => user, :target => team) }

    it "should generate an activity feed item" do
      expect {
        team.accepted_invitation_to_join(user, invitation)
      }.to change { team.activity_feed_items.count }.by(1)
    end
  end

  describe "#accepted_invitation_to_manage" do
    let(:team) { FactoryGirl.create(:team) }
    let(:user) { FactoryGirl.create(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :user => user, :target => team) }

    it "should generate an activity feed item" do
      expect {
        team.accepted_invitation_to_manage(user, invitation)
      }.to change { team.activity_feed_items.count }.by(1)
    end
  end

end
