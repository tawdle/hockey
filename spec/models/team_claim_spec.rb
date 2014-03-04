require 'spec_helper'

describe TeamClaim do
  describe "#validations" do
    let(:team_claim) { FactoryGirl.build(:team_claim) }
    subject { team_claim }

    it { should be_valid }
    it { should validate_presence_of(:team) }
  end
end
