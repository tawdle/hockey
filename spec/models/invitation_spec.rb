require 'spec_helper'

describe Invitation do
  let(:mail) { double("mail", :deliver => true) }
  let(:invitation) { FactoryGirl.build(:invitation) }

  describe "#validations" do
    it "creates a valid object" do
      invitation.should be_valid
    end
    it "requires a creator" do
      invitation.creator = nil
      invitation.should_not be_valid
    end
    it "requires an email address" do
      invitation.email = nil
      invitation.should_not be_valid
    end
    it "requires a target" do
      invitation.target = nil
      invitation.should_not be_valid
    end
    it "requires a predicate" do
      invitation.predicate = nil
      invitation.should_not be_valid
    end
    it "allows only one invitation per email/predicate/target" do
      other_invitation = FactoryGirl.create(:invitation,
                                            :email => invitation.email,
                                            :predicate => invitation.predicate,
                                            :target => invitation.target)
      invitation.should_not be_valid
    end

    describe "#username_or_email" do
      before do
        invitation.email = nil
      end

      it "requires a valid username or email address" do
        invitation.username_or_email = "foo"
        invitation.should_not be_valid
      end

      it "requires a provided username to match an existing user" do
        invitation.username_or_email = "@foo"
        invitation.should_not be_valid
        invitation.username_or_email = FactoryGirl.create(:user).at_name
        invitation.should be_valid
      end

      it "accepts any email address" do
        invitation.username_or_email = "foo@foo.com"
        invitation.should be_valid
      end
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
    let(:invitations) { {
      :manage_league => invitation,
      :manage_team => FactoryGirl.build(:invitation, :target => FactoryGirl.build(:team)),
      :join_league => FactoryGirl.build(:invitation, :predicate => :join),
      :claim_player => FactoryGirl.build(:invitation, :predicate => :claim, :target => FactoryGirl.build(:player)),
      :mark_league => FactoryGirl.build(:invitation, :predicate => :mark, :target => FactoryGirl.build(:league))
    } }
    let(:messages) { [:manage_league, :manage_team, :join_league, :claim_player, :mark_league] }

    it "sets the code" do
      invitation.code.should be_nil
      invitation.save!
      invitation.code.should_not be_nil
    end

    it "emails the invitations" do
      invitations.each do |message, invitation|
        InvitationMailer.should_receive(:invite).with(invitation).and_return(mail)
        invitation.save!
      end
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
      target.should_receive(:accepted_invitation_to_manage).with(user, invitation).and_return(mail)
      expect {
        invitation.accept!(user)
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

    it "should try to notify target" do
      target.should_receive(:respond_to?).with("declined_invitation_to_manage").and_return(true)
      target.should_receive("declined_invitation_to_manage").with(user, invitation).and_return(mail)
      expect {
        invitation.decline!
      }.to change { invitation.state }.from(:pending).to(:declined)
    end
  end

  describe ".find" do
    let(:invitation) { FactoryGirl.create(:invitation) }

    it "should find an invitation by code" do
      described_class.find(invitation.code).should == invitation
    end
  end
end
