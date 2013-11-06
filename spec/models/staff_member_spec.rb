require 'spec_helper'

describe StaffMember do
  describe "#validations" do
    let(:staff_member) { FactoryGirl.build(:staff_member) }

    it "creates a valid object" do
      staff_member.should be_valid
    end

    it "requires a name" do
      staff_member.name = nil
      staff_member.should_not be_valid
    end

    it "requires a team" do
      staff_member.team = nil
      staff_member.should_not be_valid
    end

    it "requires a role" do
      staff_member.role = nil
      staff_member.should_not be_valid
    end

    it "requires a valid role" do
      staff_member.role = "foo"
      staff_member.should_not be_valid
    end
  end
  it_behaves_like "a model that implements soft delete"
end
