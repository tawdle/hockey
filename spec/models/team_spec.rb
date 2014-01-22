require 'spec_helper'

describe Team do
  describe "#validations" do
    let(:team) { FactoryGirl.build(:team) }
    it "should generate a valid object" do
      team.should be_valid
    end
    it "should require a name" do
      team.name = ""
      team.should_not be_valid
      team.name = nil
      team.should_not be_valid
    end
    it "should require a league" do
      team.league = nil
      team.should_not be_valid
    end
    it "should require a system name" do
      team.system_name = nil
      team.should_not be_valid
    end
  end

  describe "#at_name" do
    let(:team) { FactoryGirl.build(:team) }

    it "should delegate to the system name" do
      team.at_name.should == "@" + team.system_name.name
    end
  end

  describe "#accepted_invitation_to_manage" do
    let(:team) { FactoryGirl.create(:team) }
    let(:user) { FactoryGirl.create(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :user => user, :target => team) }

    it "should create an authorization for the user to manage the team" do
      team.accepted_invitation_to_manage(user, invitation)
      team.reload.managers.should include(user)
    end

    it "should generate an activity feed item" do
      expect {
        team.accepted_invitation_to_manage(user, invitation)
      }.to change { ActivityFeedItem.count }.by(1)
    end
    context "with an already-existing authorization" do
      let!(:authorization) { FactoryGirl.create(:authorization, :user => user, :role => :manager, :authorizable => team) }

      it "should not fail" do
        expect {
          team.accepted_invitation_to_manage(user, invitation)
        }.not_to raise_exception
      end
    end
  end
  it_behaves_like "a model that implements soft delete"
end
