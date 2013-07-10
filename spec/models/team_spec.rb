require 'spec_helper'

describe Team do
  describe "#validations" do
    before do
      @team = FactoryGirl.build(:team)
    end
    it "should generate a valid object" do
      @team.should be_valid
    end
    it "should require a name" do
      @team.name = ""
      @team.should_not be_valid
      @team.name = nil
      @team.should_not be_valid
    end
  end

  describe "#accepted_invitation_to_join" do
    let(:team) { FactoryGirl.create(:team) }
    let(:user) { FactoryGirl.create(:user) }
    it "should add the user to the list of team members" do
      expect {
        team.accepted_invitation_to_join(user)
      }.to change { team.members.include?(user) }.from(false).to(true)
    end

    it "should generate an activity feed item" do
      expect {
        team.accepted_invitation_to_join(user)
      }.to change { team.activity_feed_items.count }.by(1)
    end
  end

end
