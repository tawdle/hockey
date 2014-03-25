class UnsubscribeController < ApplicationController
  load_resource :user
  skip_authorization_check

  before_filter :check_token

  def unsubscribe
    category = "subscribed_#{params[:category]}"
    raise ActiveRecord::RecordNotFound unless @user.respond_to?("#{category}=")
    @user.update_attribute(category, false)
    render :success
  end

  private

  def check_token
    raise CanCan::AccessDenied unless @user.unsubscribe_token == params[:token]
  end
end
