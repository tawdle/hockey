module UsersHelper
  include Rails.application.routes.url_helpers

  def format_user_link(user)
    "<span class='username'>@#{link_to(user.name, user)}</span>".html_safe if user
  end

  def format_username_link(username)
    "<span class='username'>@#{link_to(username, system_name_path(username))}</span>".html_safe if username
  end

  def format_player_link(player)
    if player
      "<span class='username'>@#{link_to(player.team_and_jersey, player)}</span>".html_safe
    end
  end

  def format_playername_link(playername)
    if playername
      teamname, jersey_number = playername.split("#")
      "<span class='username'>@#{link_to(playername, system_name_path(teamname, :j => jersey_number))}</span>".html_safe
    end
  end

  def format_message_with_usernames(msg)
    username_matches = msg.scan(Mention::NameOrPlayerPattern)
      if username_matches
        username_matches = username_matches.flatten
        msg = msg.clone
        username_matches.each do |username|
          if username.include?("#")
            msg.gsub!("@#{username}", format_playername_link(username))
          else
            msg.gsub!("@#{username}", format_username_link(username))
          end
        end
      end
    msg
  end
end
