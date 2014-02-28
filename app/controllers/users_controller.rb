class UsersController < ApplicationController
  load_resource :except => [:email_available, :system_name_available]
  authorize_resource :except => [:show, :email_available, :system_name_available]
  skip_authorization_check :only => [:show, :email_available, :system_name_available]

  def show
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

  def email_available
    email = params[:user] && params[:user][:email]

    respond_to do |format|
      if email
        format.json { render json: User.where(:email => email).none? }
      else
        format.json { render json: false }
      end
    end
  end

  def system_name_available
    name = params[:user] && params[:user][:system_name_attributes] && params[:user][:system_name_attributes][:name]

    respond_to do |format|
      if name
        format.json { render json: SystemName.where(:name => name.downcase).none? }
      else
        format.json { render json: false }
      end
    end
  end
end
