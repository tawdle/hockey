class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user] && params[:user].delete(:mini)
      self.resource = User.new(params[:user])
      render :new
    else
      super
    end
  end
end
