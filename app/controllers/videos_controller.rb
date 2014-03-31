class VideosController < ApplicationController
  load_and_authorize_resource

  def show
    redirect_to @video.secure_url
  end

  private

  def use_facebook
    true
  end

  def use_twitter
    true
  end
end
