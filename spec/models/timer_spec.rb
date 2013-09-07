require 'spec_helper'

describe Timer do
  let(:timer) { FactoryGirl.build(:timer) }

  describe "#validations" do
    it "creates a valid object" do
      timer.should be_valid
    end
  end

  context "with an unstarted timer" do
    it "raises when asked for elapsed time" do
      expect {
        timer.elapsed_time
      }.to raise_error
    end
    it "reports the time_remaining" do
      timer.time_remaining.should == timer.duration
    end
  end

  context "with a started timer" do
    before { timer.start! }

    it "reports the elapsed time" do
      timer.elapsed_time.should_not be_nil
    end
    it "reports the time_remaining" do
      timer.time_remaining.should be < timer.duration
    end
    it "allows reset" do
      timer.reset!
      timer.state.should == "created"
    end
  end

  context "with a paused timer" do
    before do
      timer.start!
      timer.pause!
    end

    it "reports the elapsed time" do
      timer.elapsed_time.should_not be_nil
      timer.elapsed_time.should == timer.elapsed_time
    end
    it "reports the time_remaining" do
      timer.time_remaining.should be < timer.duration
    end
    it "allows reset" do
      timer.reset!
      timer.state.should == "created"
    end
    it "allows setting the elapsed time manually" do
      timer.elapsed_time = 100
      timer.elapsed_time.should == 100
    end

    it "allows setting the elapsed time with a string" do
      timer.elapsed_time = "2:45"
      timer.elapsed_time.should == 2 * 60 + 45
    end

    it "clamps the elapsed time at the duration" do
      timer.elapsed_time = timer.duration * 2
      timer.elapsed_time.should == timer.duration
    end
  end

  context "with a restarted timer" do
    before do
      timer.start!
      timer.pause!
      timer.start!
    end

    it "reports the elapsed time" do
      timer.elapsed_time.should_not be_nil
    end
    it "reports the time_remaining" do
      timer.time_remaining.should be < timer.duration
    end
    it "allows reset" do
      timer.reset!
      timer.state.should == "created"
    end
  end
end
