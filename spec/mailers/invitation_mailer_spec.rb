require "spec_helper"

describe InvitationMailer do
  ['en', 'fr'].each do |locale|

    describe "manage_league" do
      let(:league) { FactoryGirl.build(:league) }
      let(:invitation) { FactoryGirl.build(:invitation, :target => league, :code => "foo", :language => locale) }
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
      let(:league) { FactoryGirl.build(:league) }
      let(:invitation) { FactoryGirl.build(:invitation, :target => league, :code => "foo") }
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

    describe "manage_location" do
      let(:location) { FactoryGirl.build(:league) }
      let(:invitation) { FactoryGirl.build(:invitation, :target => location, :code => "foo") }
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
      let(:team) { FactoryGirl.build(:team) }
      let(:invitation) { FactoryGirl.build(:invitation, :target => team, :code => "foo") }
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

    describe "#claim_player" do
      let(:player) { FactoryGirl.build(:player) }
      let(:invitation) { FactoryGirl.build(:invitation, :target => player, :code => "foo") }
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
end
