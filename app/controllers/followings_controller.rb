class FollowingsController < ApplicationController
  load_and_authorize_resource :only => :destroy

  def create
    @following = Following.new(params[:following])
    authorize! :create, @following

    respond_to do |format|
      if @following.save
        format.html { redirect_to request.env["HTTP_REFERER"] || @following.followable, notice: "You are now following #{@following.followable.name}." }
        format.json { render json: @following, status: :created, location: @following.followable }
      else
        format.html { redirect_to :back, error: "Follow action failed." }
        format.json { render json: @following.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @following.destroy
        format.html { redirect_to :back, notice: "You are no longer following #{@following.followable.name}."}
        format.json { head :no_content }
      else
        format.html { redirect_to :back, error: "Unable to stop following." }
        format.json { render json: @following.errors, status: :unprocessable_entity }
      end
    end
  end
end
