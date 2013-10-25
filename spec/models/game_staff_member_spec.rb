require 'spec_helper'

describe GameStaffMember do
  describe "#validations" do
    let(:game_staff_member) { FactoryGirl.build(:game_staff_member) }

    it "builds a valid object" do
      game_staff_member.should be_valid
    end

    it "requires a game" do
      game_staff_member.game = nil
      game_staff_member.should_not be_valid
    end

    it "requires a staff member" do
      game_staff_member.staff_member = nil
      game_staff_member.should_not be_valid
    end

    it "requires a role" do
      game_staff_member.role = nil
      game_staff_member.should_not be_valid
    end

    it "requires a valid role" do
      game_staff_member.role = "foo"
      game_staff_member.should_not be_valid
    end

    it "requires the staff member to be on one of the game's teams" do
      game_staff_member.staff_member = FactoryGirl.build(:staff_member)
      game_staff_member.should_not be_valid
    end
  end
end
