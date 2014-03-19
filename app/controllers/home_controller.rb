class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user
      @authorizations = current_user.authorizations.
        order(:authorizable_type).map(&:authorizable).compact.uniq
    end
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end

end
