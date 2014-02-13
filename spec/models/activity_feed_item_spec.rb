require 'spec_helper'

describe ActivityFeedItem do
  describe "#validations" do
    let(:activity_feed_item) { FactoryGirl.build(:activity_feed_item) }

    it "should create a valid object" do
      activity_feed_item.should be_valid
    end
  end

  describe ".for_user" do
    let(:us) { FactoryGirl.create(:user) }

    it "finds posts authored by us" do
      our_post = FactoryGirl.create(:user_post, :creator => us)
      their_post = FactoryGirl.create(:user_post)
      ActivityFeedItem.for_user(us).should include(our_post)
      ActivityFeedItem.for_user(us).should_not include(their_post)
    end

    it "finds posts mentioning someone we follow" do
      followed_post = FactoryGirl.create(:user_post)
      unfollowed_post = FactoryGirl.create(:user_post)
      FactoryGirl.create(:following, :user => us, :followable => followed_post.creator)
      ActivityFeedItem.for_user(us).should include(followed_post)
      ActivityFeedItem.for_user(us).should_not include(unfollowed_post)
    end

    it "finds posts mentioning us" do
      post_about_us = FactoryGirl.create(:user_post, :message => "I just love #{us.at_name}")
      post_about_someone_else = FactoryGirl.create(:user_post, :message => "I don't really like #{post_about_us.creator.at_name}")
      ActivityFeedItem.for_user(us).should include(post_about_us)
      ActivityFeedItem.for_user(us).should_not include(post_about_someone_else)
    end

    it "finds posts mentioning one of our players" do
      player = FactoryGirl.create(:player, :user => us)
      other_player = FactoryGirl.create(:player, :user => FactoryGirl.create(:user))
      post_about_our_player = FactoryGirl.create(:user_post, :message => "That #{player.at_name} is quite talented")
      post_about_other_player = FactoryGirl.create(:user_post, :message => "#{other_player.at_name} needs to learn a few things")
      ActivityFeedItem.for_user(us).should include(post_about_our_player)
      ActivityFeedItem.for_user(us).should_not include(post_about_other_player)
    end
  end
end
