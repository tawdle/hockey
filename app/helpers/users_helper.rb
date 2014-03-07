module UsersHelper
  include Rails.application.routes.url_helpers

  def format_user_link(user, klass='username')
    "<span class='#{klass}'>@#{link_to(user.cached_system_name, user)}</span>".html_safe if user
  end

  def format_team_link(team)
    "<span class='username'>@#{link_to(team.system_name.name, team)}</span>".html_safe if team && team.system_name
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

  def format_link(username, displayname)
    if username.include?("#")
      team, jersey = username.split("#")
      dest = system_name_path(team, :j => jersey)
    else
      dest = system_name_path(username)
    end
    link_to(displayname, dest, :title => username)
  end

  def format_message_with_usernames(msg)
    matches = msg.scan(Mention::FeedNamePattern)
    if matches.any?
      msg = ERB::Util.html_escape(msg)
      matches.each do |username, displayname|
        source = Regexp.escape("[[@#{username} #{ERB::Util.html_escape(displayname)}]]")
        msg.gsub!(/#{source}/, format_link(username, displayname))
      end
    end

    username_matches = msg.scan(Mention::NameOrPlayerPattern)
    if username_matches
      username_matches = username_matches.flatten
      msg = ERB::Util.html_escape(msg) unless matches
      username_matches.each do |username|
        at_name = Regexp.escape("@#{username}")
        if username.include?("#")
          msg.gsub!(/#{at_name}\b/, format_playername_link(username))
        else
          msg.gsub!(/#{at_name}\b/, format_username_link(username))
        end
      end
    end
    msg
  end
end
