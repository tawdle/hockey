require 'spec_helper'

describe Invitation do
  describe "#validations" do
    before do
      @invitation = FactoryGirl.build(:invitation)
    end
    it "creates a valid object" do
      @invitation.should be_valid
    end
    it "requires an email address" do
      @invitation.email = nil
      @invitation.should_not be_valid
    end
    it "requires a target" do
      @invitation.target = nil
      @invitation.should_not be_valid
    end
    it "requires an action" do
      @invitation.action = nil
      @invitation.should_not be_valid
    end
    it "allows only one invitation per email/action/target" do
      other_invitation = FactoryGirl.create(:invitation,
                                            :email => @invitation.email,
                                            :action => @invitation.action,
                                            :target => @invitation.target)
      @invitation.should_not be_valid
    end
  end

  describe "#defaults" do
    it "sets state to pending" do
      invitation = Invitation.new
      invitation.state.should == :pending
    end
  end

  describe "#on_create" do
    let(:invitation) { FactoryGirl.build(:invitation) }
    let(:other_invitation) { FactoryGirl.build(:invitation, :target => FactoryGirl.build(:team)) }
    let(:one_more_invitation) { FactoryGirl.build(:invitation, :action => :join) }

    it "sets the code" do
      invitation.code.should be_nil
      invitation.save!
      invitation.code.should_not be_nil
    end
    it "emails the invitation" do
      Invitations.should_receive(:manage_league).with(invitation).and_return(true)
      invitation.save!
      Invitations.should_receive(:manage_team).with(other_invitation).and_return(true)
      other_invitation.save!
      Invitations.should_receive(:join_league).with(one_more_invitation).and_return(true)
      one_more_invitation.save!
    end
  end
  describe "#accept" do
    let(:user) { FactoryGirl.build(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :email => user.email) }
    let(:target) { invitation.target }

    before do
      User.stub(:find_by_email).and_return(user)
    end

    it "should notify target" do
      target.should_receive(:accepted_invitation_to_manage) # .with(user).and_return(true)
      expect {
        invitation.accept!
      }.to change { invitation.state }.from(:pending).to(:accepted)
    end
  end
  describe "#decline" do
    let(:user) { FactoryGirl.build(:user) }
    let(:invitation) { FactoryGirl.build(:invitation, :email => user.email) }
    let(:target) { invitation.target }

    before do
      User.stub(:find_by_email).and_return(user)
    end

    it "should notify target" do
      target.should_receive(:declined_invitation_to_manage).with(user).and_return(true)
      expect {
        invitation.decline!
      }.to change { invitation.state }.from(:pending).to(:declined)
    end
  end
end
