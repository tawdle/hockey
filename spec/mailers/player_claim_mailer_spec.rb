require 'spec_helper'

describe PlayerClaimMailer do
  describe "#created" do
    let(:player_claim) { FactoryGirl.create(:player_claim) }
    let(:mail) { described_class.created(player_claim) }

    it "should include the right subject" do
      mail.subject.should == t("player_claim_mailer.created.subject", :locale => :fr)
    end

    it "should be addressed to the team managers" do
      mail.to.should == player_claim.player.team.managers.map(&:email)
    end
  end

  describe "#approved" do
    let(:player_claim) { FactoryGirl.build(:player_claim, :approved) }
    let(:mail) { described_class.approved(player_claim) }

    it "should include the right subject" do
      mail.subject.should == t("player_claim_mailer.approved.subject", :locale => :fr)
    end

    it "should be addressed to the creator" do
      mail.to.should == [player_claim.creator.email]
    end
  end

  describe "#denied" do
    let(:player_claim) { FactoryGirl.build(:player_claim, :denied) }
    let(:mail) { described_class.denied(player_claim) }

    it "should include the right subject" do
      mail.subject.should == t("player_claim_mailer.denied.subject", :locale => :fr)
    end

    it "should be addressed to the creator" do
      mail.to.should == [player_claim.creator.email]
    end
  end
end

