module UsersHelper
  def format_user_link(user)
    link_to "@#{user.name}", user, :class => "user_name"
  end
end
