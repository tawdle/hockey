class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user
      @authorizations = current_user.authorizations.
        order(:authorizable_type).map(&:authorizable).compact.uniq
    end
  end
end
