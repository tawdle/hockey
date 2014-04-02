class FeedItemsController < ApplicationController
  skip_authorization_check
  before_filter :load_feed_item, :except => [:index]

  def index
    if request.xhr?
      @feed_items = if params[:context_type] && params[:context_id]
        @context = params[:context_type].constantize.find(params[:context_id])
        @feed_items = ActivityFeedItem.for(@context)
      else
        @context = nil
        @feed_items = ActivityFeedItem.for_user(current_user)
      end
      @feed_items = @feed_items.where("activity_feed_items.id < ?", params[:last_id]) if params[:last_id]
      @more = @feed_items.count > 10
      @owner = User.find_by_id(params[:owner_id]) if params[:owner_id]
      render :layout => false
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def show
  end

  private

  def load_feed_item
    @feed_item = ActivityFeedItem.find(params[:id])
  end
end
