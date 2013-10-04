class UsersController < ApplicationController
  load_resource
  authorize_resource :except => :show
  skip_authorization_check :only => :show

  def show
    if current_user && current_user.following?(@user)
      @unfollowing = Following.lookup(current_user, @user)
    else
      @following = Following.new(:user => current_user, :target => @user)
      @following = nil if !@following.valid? || cannot?(:create, @following)
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def impersonate
    sign_in(@user)

    respond_to do |format|
      format.html { redirect_to @user, notice: "You are now impersonating #{@user.at_name}" }
      format.json { head :no_content }
    end
  end
end
