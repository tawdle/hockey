shared_examples_for "an action that creates an activity feed item" do
  before do
    setup if defined?(setup)
  end
  it "creates an activity feed item" do
    expect {
      action
    }.to change { (defined?(type) ? type : ActivityFeedItem).count}.by(defined?(count) ? count : 1)
  end
end

shared_examples_for "a model that implements soft delete" do
  describe "#destroy" do
    let(:model) { FactoryGirl.create(described_class.name.underscore.to_sym) }
    it "sets deleted_at" do
      expect {
        model.destroy
      }.to change { model.deleted_at }.from(nil)
    end
    it "doesn't delete the object" do
      model.destroy
      model.should_not be_destroyed
    end
  end
end
