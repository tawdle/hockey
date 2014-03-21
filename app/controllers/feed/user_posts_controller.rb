class Feed::UserPostsController < ApplicationController
  def create
    @user_post = Feed::UserPost.new((params[:feed_user_post] || {}).merge(:creator => current_user))

    authorize! :create, @user_post

    respond_to do |format|
      if @user_post.save
        format.html do
          if request.xhr?
            locals = {:item => @user_post }
            locals.merge!(:reply => true) if params[:reply] == true
            locals.merge!(:owner => User.find(params[:owner_id])) if params[:owner_id]
            render :partial => "feed_item", :locals => locals, :layout => false
          else
            redirect_to :back, notice: t("controllers.feed.user_posts.create.success")
          end
        end
        format.json { render json: @user_post, status: :created, location: @user_post }
      else
        format.html do
          if request.xhr?
            render text: "error(s):\n#{@user_post.errors.full_messages.join('\n')}", status: :unprocessable_entity
          else
            redirect_to :back, alert: t("controllers.feed.user_posts.create.failure")
          end
        end
        format.json { render json: @user_post.errors, status: :unprocessable_entity }
      end
    end
  end
end
