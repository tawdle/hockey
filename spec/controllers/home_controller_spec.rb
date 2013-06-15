require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "returns success" do
      get :index
      response.should be_success
    end
  end
end
