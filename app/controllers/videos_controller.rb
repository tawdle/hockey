class VideosController < ApplicationController
  load_and_authorize_resource

  def show
    @goal = @video.goal
    @game = @goal.game
  end

  def destroy
    @video.destroy
    redirect_to @video.goal.game, :notice => t("controllers.videos.destroy")
  end

  private

  def use_facebook
    true
  end

  def use_twitter
    true
  end
end
