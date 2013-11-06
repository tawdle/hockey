require 'spec_helper'

describe League do
  describe "#validations" do
    let(:league) { FactoryGirl.build(:league) }

    it "generates a valid object" do
      league.should be_valid
    end
    it "requires a name" do
      league.name = ""
      league.should_not be_valid
      league.name = nil
      league.should_not be_valid
    end
    it "requires league's name be unique" do
      other_league = FactoryGirl.create(:league)
      league.name = other_league.name
      league.should_not be_valid
    end
    it "allows an empty classification" do
      league.classification = nil
      league.should be_valid
    end
    it "requires a classification to be valid" do
      league.classification = :foo
      league.should_not be_valid
    end
    it "requires a valid division" do
      league.division = :foo
      league.should_not be_valid
    end
  end
  describe "#accepted_invitation_to_manage" do
    let(:league) { FactoryGirl.build(:league) }
    let(:user) { FactoryGirl.build(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :user => user, :target => league) }

    it "should add the provided user to the list of managers" do
      expect {
        league.accepted_invitation_to_manage(user, invitation)
      }.to change { league.managers.count }.by(1)
    end
    let(:action) { league.accepted_invitation_to_manage(user, invitation) }
    it_behaves_like "an action that creates an activity feed item"
    context "with an already-existing authorization" do
      let!(:authorization) { FactoryGirl.create(:authorization, :user => user, :role => :manager, :authorizable => league) }

      it "should not fail" do
        expect {
          league.accepted_invitation_to_manage(user, invitation)
        }.not_to raise_exception
      end
    end
  end
  describe "#accepted_invitation_to_mark" do
    let(:league) { FactoryGirl.build(:league) }
    let(:user) { FactoryGirl.build(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :user => user, :predicate => :mark, :target => league) }

    it "should add the provided user to the list of markers" do
      expect {
        league.accepted_invitation_to_mark(user, invitation)
      }.to change { league.markers.count }.by(1)
    end

    context "with an already-existing authorization" do
      let!(:authorization) { FactoryGirl.create(:authorization, :user => user, :role => :marker, :authorizable => league) }

      it "should not fail" do
        expect {
          league.accepted_invitation_to_mark(user, invitation)
        }.not_to raise_exception
      end
    end
    let(:action) { league.accepted_invitation_to_mark(user, invitation) }
    it_behaves_like "an action that creates an activity feed item"
  end
  it_behaves_like "a model that implements soft delete"
end
