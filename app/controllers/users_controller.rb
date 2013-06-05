class UsersController < ApplicationController
  load_resource
  authorize_resource :except => :show
  skip_authorization_check :only => :show

  def show
  end
end
