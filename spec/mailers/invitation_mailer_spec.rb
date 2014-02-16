require "spec_helper"

describe InvitationMailer do

  let(:locale) { "fr" }
  let(:invitation) { FactoryGirl.build(:invitation, :predicate => predicate, :target => target, :code => "foo", :language => locale) }
  let(:mail) { InvitationMailer.invite(invitation) }

  describe "manage_league" do
    let(:target) { FactoryGirl.build(:league) }
    let(:predicate) { :manage }

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
    let(:predicate) { :mark }

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
    let(:predicate) { :mark }

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
    let(:predicate) { :manage }

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
    let(:predicate) { :manage }

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
    let(:predicate) { :manage }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.manage_tournament.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "#follow_player" do
    let(:target) { FactoryGirl.build(:player) }
    let(:predicate) { :follow }

    it "renders the headers" do
      mail.subject.should eq(t("invitation_mailer.follow_player.subject", :locale => locale))
      mail.to.should eq([invitation.email])
      mail.from.should eq(["mailer@bigshot.io"])
    end

    it "renders the body" do
      mail.body.encoded.should match(t("navigation.greeting", :locale => locale))
    end
  end

  describe "#claim_player" do
    let(:target) { FactoryGirl.build(:player) }
    let(:predicate) { :claim }

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
