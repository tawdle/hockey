module UsersHelper
  def format_user_link(user)
    "<span class='username'>@#{link_to(user.name, user.nameable || user)}</span>".html_safe if user
  end

  def format_message_with_usernames(msg)
    username_matches = msg.scan(/\@[a-zA-Z0-9_]*/)
    if username_matches
      msg = msg.clone
      usernames = username_matches.uniq.map {|s| s[1..-1] }
      User.where(:name => usernames).each do |user|
        msg.gsub!("@#{user.name}", format_user_link(user))
      end
    end
    msg
  end
end
