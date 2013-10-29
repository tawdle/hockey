# encoding: utf-8

require 'spec_helper'

describe User do
  describe "#validations" do
    let(:user) { FactoryGirl.build(:user) }
    it "should generate a valid object" do
      user.should be_valid
    end
  end
end

