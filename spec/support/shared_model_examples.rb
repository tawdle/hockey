shared_examples_for "an action that creates an activity feed item" do
  it "should create an activity feed item" do
    expect {
      action
    }.to change { ActivityFeedItem.count}.by(defined?(count) ? count : 1)
  end
end
