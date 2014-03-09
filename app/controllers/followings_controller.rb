class FollowingsController < ApplicationController
  load_and_authorize_resource :only => :destroy

  def create
    @following = Following.new(params[:following])
    authorize! :create, @following

    respond_to do |format|
      if @following.save
        format.html { redirect_to request.env["HTTP_REFERER"] || @following.followable, notice: t("controllers.followings.create.success", :name => @following.followable.name) }
        format.json { render json: @following, status: :created, location: @following.followable }
      else
        format.html { redirect_to :back, error: t("controllers.followings.create.failure") }
        format.json { render json: @following.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @following.destroy
        format.html { redirect_to :back, notice: t("controllers.followings.destroy.success", :name => @following.followable.name) }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, error: t("controllers.followings.destroy.failure") }
        format.json { render json: @following.errors, status: :unprocessable_entity }
      end
    end
  end
end
