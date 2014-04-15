class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user] && params[:user].delete(:mini)
      self.resource = User.new(params[:user])
      render :new
    else
      super
    end
  end

  def created
  end

  def after_sign_up_path_for(resource)
    account_created_path
  end
end
