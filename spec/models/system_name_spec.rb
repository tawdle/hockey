# encoding: utf-8

require 'spec_helper'

describe SystemName do
  describe "#validations" do
    let(:system_name) { FactoryGirl.build(:system_name) }

    it "builds a valid object" do
      system_name.should be_valid
    end

    it "requires a nameable" do
      system_name.nameable = nil
      system_name.should_not be_valid
    end

    it "requires a unique nameable" do
      FactoryGirl.create(:system_name, :nameable => system_name.nameable)
      expect {
        system_name.save!
      }.to raise_error
    end

    describe "#name" do
      it "requires a name" do
        system_name.name = ""
        system_name.should_not be_valid
        system_name.name = nil
        system_name.should_not be_valid
      end
      it "requires a unique name" do
        FactoryGirl.create(:system_name, :name => system_name.name)
        system_name.should_not be_valid
      end
      it "prohibits invalid characters" do
        system_name.name = "foo*&^"
        system_name.should_not be_valid
      end
      it "requires at least 3 chars" do
        system_name.name = "ab"
        system_name.should_not be_valid
      end
      it "requires fewer than 32 chars" do
        system_name.name = "x" * 33
        system_name.should_not be_valid
      end
      it "allows accented characters" do
        system_name.name = "éric"
        system_name.should be_valid
      end
      it "allows numbers" do
        system_name.name = "foo4u"
        system_name.should be_valid
      end
      it "allows _ and -" do
        system_name.name = "_-_"
        system_name.should be_valid
      end
    end
  end
end
