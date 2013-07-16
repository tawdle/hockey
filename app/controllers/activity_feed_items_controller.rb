class ActivityFeedItemsController < ApplicationController
  def create
    @activity_feed_item = ActivityFeedItem.new(params[:activity_feed_item].merge(:creator => current_user))

    authorize! :create, @activity_feed_item

    respond_to do |format|
      if @activity_feed_item.save
        format.html { redirect_to :back, notice: "Your update has been posted." }
        format.json { render json: @activity_feed_item, status: :created, location: @activity_feed_item }
      else
        format.html { redirect_to :back, alert: "Your update has been rejected." }
        format.json { render json: @activity_feed_item.errors, status: :unprocessable_entity }
      end
    end
  end
end
