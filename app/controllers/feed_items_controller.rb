class FeedItemsController < ApplicationController
  skip_authorization_check
  before_filter :load_feed_item

  def show
  end

  private

  def load_feed_item
    @feed_item = ActivityFeedItem.find(params[:id])
  end
end
