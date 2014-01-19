shared_examples "a controller action requiring authentication" do
  it "redirects to root" do
    do_request
    expect(response).to redirect_to(root_url)
  end
end

shared_examples "a controller action requiring an authenticated admin" do
  context "when not logged in" do
    it_behaves_like "a controller action requiring authentication"
  end
  context "when logged in as an ordinary user" do
    before { sign_in(FactoryGirl.create(:user)) }
    it_behaves_like "a controller action requiring authentication"
  end
  context "when logged in as an admin" do
    before { sign_in_as_admin }
    it "succeeds" do
      do_request
    end
  end
end
