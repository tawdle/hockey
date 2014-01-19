require 'spec_helper'

describe LocationsController do
  let(:location) { FactoryGirl.create(:location) }

  context "without a logged in user" do
    describe "#show" do
      def do_request
        get :show, :id => location.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end
  end

  context "with a logged in admin" do
    before { sign_in_as_admin }

    describe "#index" do
      def do_request
        get :index
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#new" do
      def do_request
        get :new
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#edit" do
      def do_request
        get :edit, :id => location.to_param
      end

      it "should work" do
        do_request
        response.should be_ok
      end
    end

    describe "#create" do
      def do_request
        post :create, :location => {:name => "My New Location", :address_1 => "87 Truman Road", :city => "Newton Centre", :state => "MA", :zip => "02159", :country => "US", :system_name_attributes => {:name => "foo"} }
      end

      it "should create a new location" do
        expect {
          do_request
          response.should be_redirect
        }.to change { Location.count }.by(1)
      end
    end

    describe "#update" do
      def do_request
        put :update, :id => location.id, :location => {:name => "My Updated Name" }
      end

      it "should change the name" do
        expect {
          do_request
        }.to change { location.reload.name }.to("My Updated Name")
      end
    end
  end
end
