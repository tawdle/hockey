class Feed::UserPostsController < ApplicationController
  def create
    @user_post = Feed::UserPost.new((params[:feed_user_post] ||{}).merge(:creator => current_user))

    authorize! :create, @user_post

    respond_to do |format|
      if @user_post.save
        format.html { redirect_to :back, notice: "Your update has been posted." }
        format.json { render json: @user_post, status: :created, location: @user_post }
      else
        format.html { redirect_to :back, alert: "Your update has been rejected." }
        format.json { render json: @user_post.errors, status: :unprocessable_entity }
      end
    end
  end
end
