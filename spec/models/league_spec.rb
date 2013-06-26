require 'spec_helper'

describe League do
  describe "#validations" do
    before do
      @league = FactoryGirl.build(:league)
    end
    it "generates a valid object" do
      FactoryGirl.build(:league).should be_valid
    end
    it "requires a name" do
      @league.name = ""
      @league.should_not be_valid
      @league.name = nil
      @league.should_not be_valid
    end
    it "requires league's name be unique" do
      other_league = FactoryGirl.create(:league)
      @league.name = other_league.name
      @league.should_not be_valid
    end
  end
  describe "#accepted_invitation_to_manage" do
    let(:league) { FactoryGirl.build(:league) }
    let(:user) { FactoryGirl.build(:user) }

    it "should add the provided user to the list of managers" do
      expect {
        league.accepted_invitation_to_manage(user)
      }.to change { league.managers.count }.by(1)
    end
  end
end
