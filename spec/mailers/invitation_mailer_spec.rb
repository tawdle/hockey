require "spec_helper"

describe InvitationMailer do

  let(:locale) { "fr" }
  let(:invitation) { FactoryGirl.build(:invitation, :target => target, :code => "foo", :language => locale) }

  describe "manage_league" do
    let(:target) { FactoryGirl.build(:league) }
    let(:mail) { InvitationMailer.manage_league(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.manage_league.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "mark_league" do
    let(:target) { FactoryGirl.build(:league) }
    let(:mail) { InvitationMailer.mark_league(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.mark_league.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "mark_tournament" do
    let(:target) { FactoryGirl.build(:tournament) }
    let(:mail) { InvitationMailer.mark_tournament(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.mark_tournament.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "manage_location" do
    let(:target) { FactoryGirl.build(:location) }
    let(:mail) { InvitationMailer.manage_location(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.manage_location.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "manage_team" do
    let(:target) { FactoryGirl.build(:team) }
    let(:mail) { InvitationMailer.manage_team(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.manage_team.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "manage_tournament" do
    let(:target) { FactoryGirl.build(:tournament) }
    let(:mail) { InvitationMailer.manage_tournament(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.manage_tournament.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "#claim_player" do
    let(:target) { FactoryGirl.build(:player) }
    let(:mail) { InvitationMailer.claim_player(invitation) }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.claim_player.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end
end
