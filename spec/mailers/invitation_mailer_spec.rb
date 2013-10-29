require "spec_helper"

describe InvitationMailer do
  describe "manage_league" do
    let(:league) { FactoryGirl.build(:league) }
    let(:invitation) { FactoryGirl.build(:invitation, :target => league, :code => "foo") }
    let(:mail) { InvitationMailer.manage_league(invitation) }

    it "renders the headers" do
      mail.subject.should eq("Invitation to Manage League")
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@powerplay.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello!")
    end
  end

  describe "mark_league" do
    let(:league) { FactoryGirl.build(:league) }
    let(:invitation) { FactoryGirl.build(:invitation, :target => league, :code => "foo") }
    let(:mail) { InvitationMailer.mark_league(invitation) }

    it "renders the headers" do
      mail.subject.should eq("Invitation to become Marker for League")
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@powerplay.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello!")
    end
  end

  describe "manage_location" do
    let(:location) { FactoryGirl.build(:league) }
    let(:invitation) { FactoryGirl.build(:invitation, :target => location, :code => "foo") }
    let(:mail) { InvitationMailer.manage_location(invitation) }

    it "renders the headers" do
      mail.subject.should eq("Invitation to Manage Location")
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@powerplay.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello!")
    end
  end

  describe "manage_team" do
    let(:team) { FactoryGirl.build(:team) }
    let(:invitation) { FactoryGirl.build(:invitation, :target => team, :code => "foo") }
    let(:mail) { InvitationMailer.manage_team(invitation) }

    it "renders the headers" do
      mail.subject.should eq("Invitation to Manage Team")
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@powerplay.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello!")
    end
  end

  describe "#claim_player" do
    let(:player) { FactoryGirl.build(:player) }
    let(:invitation) { FactoryGirl.build(:invitation, :target => player, :code => "foo") }
    let(:mail) { InvitationMailer.claim_player(invitation) }

    it "renders the headers" do
      mail.subject.should eq("Invitation to Claim Player")
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@powerplay.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello!")
    end
  end
end
