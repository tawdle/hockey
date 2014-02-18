class VideosController < ApplicationController
  load_and_authorize_resource

  def show
    @goal = @video.goal
    @game = @goal.game
  end

  def destroy
    @video.destroy
    redirect_to @video.goal.game, :notice => "The video has been deleted"
  end
end
