require 'spec_helper'

describe TeamMembership do
  describe "#validations" do
    before do
      @team_membership = FactoryGirl.build(:team_membership)
    end
    it "should be valid" do
      @team_membership.should be_valid
    end
    it "should require a team" do
      @team_membership.team = nil
      @team_membership.should_not be_valid
    end
    it "should require a member" do
      @team_membership.member = nil
      @team_membership.should_not be_valid
    end
    it "should require team/user combo to be unique" do
      @team_membership.save!
      other_membership = FactoryGirl.build(:team_membership, :member => @team_membership.member, :team => @team_membership.team)
      other_membership.should_not be_valid
    end
  end
end
