class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user
      current_user.update_attribute(:last_viewed_home_page_at, Time.now)
    end
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def press
  end

  def contact
  end

end
