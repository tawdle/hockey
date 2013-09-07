require 'spec_helper'

describe CheckTimerExpirationJob do
  let(:timer) { double("Timer", :id => 7) }
  let(:job)  { described_class.new(timer.id) }
  describe "#perform" do
    it "checks for expiration of the timer" do
      Timer.stub(:find_by_id).and_return(timer)
      timer.should_receive(:check_expiration)
      job.perform
    end
    it "exits silently if the timer has been deleted" do
      Timer.stub(:find_by_id).and_return(nil)
      expect {
        job.perform
      }.not_to raise_error
    end
  end
end
