class TypeaheadController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def get_users
    query = params[:q]

    if query.length > 1 && query.starts_with?('@')
      result = User.
        select("name").
        where("lower(name) like lower(?)", "#{query[1..-1]}%").
        limit(5).
        order(:name).
        map {|u| "#{u.at_name}" }
    else
      result = []
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end
end
