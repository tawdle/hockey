require 'spec_helper'

describe PlayerClaim do
  let(:mail) { double("mail", :deliver => true) }

  describe "#validations" do
    let(:player_claim) { FactoryGirl.build(:player_claim) }
    subject { player_claim }
    it { should be_valid }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:player) }
    it { should ensure_inclusion_of(:state).in_array([:pending, :approved, :denied]) }
    it { should validate_uniqueness_of(:player_id).scoped_to(:creator_id) }

    context "when approved" do
      before { player_claim.state = :approved }
      it { should validate_presence_of(:manager) }
    end

    context "when denied" do
      before { player_claim.state = :denied }
      it { should validate_presence_of(:manager) }
    end
  end

  describe "#create" do
    let(:player_claim) { FactoryGirl.build(:player_claim) }
    it "sends an email to manager(s)" do
      PlayerClaimMailer.should receive(:created).with(player_claim).and_return(mail)
      player_claim.save!
    end
  end

  describe "#approve!" do
    context "with a pending claim" do
      let(:player_claim) { FactoryGirl.create(:player_claim) }
      let(:manager) { player_claim.player.team.managers.first }
      it "links the player and creator" do
        expect {
          player_claim.approve!(manager)
        }.to change { player_claim.player.reload.user }.from(nil).to(player_claim.creator)
      end
      it "sends an email to the creator" do
        PlayerClaimMailer.should receive(:approved).with(player_claim).and_return(mail)
        player_claim.approve!(manager)
      end
    end
    context "with an already-approved claim" do
      let(:manager) { FactoryGirl.create(:user) }
      let(:player_claim) { FactoryGirl.create(:player_claim, :state => :approved, :manager => manager) }
      it "returns true" do
        player_claim.approve!(manager).should be_true
      end

      it "sends no email" do
        PlayerClaimMailer.should_not receive(:approved)
        player_claim.approve!(manager)
      end
    end
    context "with an already-denied claim" do
      let(:manager) { FactoryGirl.create(:user) }
      let(:player_claim) { FactoryGirl.create(:player_claim, :state => :denied, :manager => manager) }
      it "returns false" do
        player_claim.approve!(manager).should be_false
      end
      it "sends no email" do
        PlayerClaimMailer.should_not receive(:approved)
        player_claim.approve!(manager)
      end
    end
  end

  describe "#deny!" do
    context "with a pending claim" do
      let(:player_claim) { FactoryGirl.create(:player_claim) }
      let(:manager) { player_claim.player.team.managers.first }
      it "doesn't link the player and creator" do
        expect {
          player_claim.deny!(manager)
        }.not_to change { player_claim.player.reload }.from(nil)
      end
      it "sends an email to the creator" do
        PlayerClaimMailer.should receive(:denied).with(player_claim).and_return(mail)
        player_claim.deny!(manager)
      end
    end
    context "with an already-approved claim" do
      let(:manager) { FactoryGirl.create(:user) }
      let(:player_claim) { FactoryGirl.create(:player_claim, :state => :approved, :manager => manager) }
      it "returns false" do
        player_claim.deny!(manager).should be_false
      end
      it "sends no email" do
        PlayerClaimMailer.should_not receive(:denied)
        player_claim.deny!(manager)
      end
    end
    context "with an already-denied claim" do
      let(:manager) { FactoryGirl.create(:user) }
      let(:player_claim) { FactoryGirl.create(:player_claim, :state => :denied, :manager => manager) }
      it "returns true" do
        player_claim.deny!(manager).should be_true
      end
      it "sends no email" do
        PlayerClaimMailer.should_not receive(:denied)
        player_claim.deny!(manager)
      end
    end
  end

  describe ".waiting_for_approval_by" do
    before do
      @player_claim = FactoryGirl.create(:player_claim)
      @manager = @player_claim.player.team.managers.first
      @other_team_claim = FactoryGirl.create(:player_claim)
      @already_approved = FactoryGirl.create(:player_claim, :player => @player_claim.player, :state => :approved, :manager => @manager)
      @already_denied = FactoryGirl.create(:player_claim, :player => @player_claim.player, :state => :denied, :manager => @manager)
    end

    subject { PlayerClaim.waiting_for_approval_by(@manager) }

    it { should include(@player_claim) }
    it { should_not include(@other_team_claim) }
    it { should_not include(@already_approved) }
    it { should_not include(@already_denied) }

  end
end
