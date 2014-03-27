module UsersHelper
  include Rails.application.routes.url_helpers

  def format_user_link(user, url_opts={}, html_opts={})
    content_tag(:span, "@" + link_to(user.cached_system_name, user_path(user, url_opts), html_opts), html_opts, false).html_safe if user
  end

  def format_team_link(team)
    "<span class='username'>@#{link_to(team.system_name.name, team)}</span>".html_safe if team && team.system_name
  end

  def format_username_link(username, url_opts={}, html_opts={})
    content_tag(:span, "@" + link_to(username, system_name_path(username, url_opts), html_opts), html_opts, false).html_safe if username
  end

  def format_player_link(player)
    if player
      "<span class='username'>@#{link_to(player.team_and_jersey, player)}</span>".html_safe
    end
  end

  def format_playername_link(playername, url_opts={}, html_opts={})
    if playername
      teamname, jersey_number = playername.split("#")
      content_tag(:span, "@" + link_to(playername, system_name_path(teamname, url_opts.merge(:j => jersey_number))), html_opts, false).html_safe
    end
  end

  def format_link(username, displayname, url_opts = {}, html_opts={})
    if username.include?("#")
      team, jersey = username.split("#")
      dest = system_name_path(team, url_opts.merge(:j => jersey))
    else
      dest = system_name_path(username, url_opts)
    end
    link_to(displayname, dest, html_opts.merge(:title => username))
  end

  def format_message_text_only(msg)
    matches = msg.scan(Mention::FeedNamePattern)
    if matches.any?
      msg = ERB::Util.html_escape(msg)
      matches.each do |username, displayname|
        source = Regexp.escape("[[@#{username} #{ERB::Util.html_escape(displayname)}]]")
        msg.gsub!(/#{source}/, displayname)
      end
    end
    msg
  end

  def format_message_with_usernames(msg, url_opts={}, html_opts={})
    msg = msg.dup
    matches = msg.scan(Mention::FeedNamePattern)
    if matches.any?
      msg = ERB::Util.html_escape(msg)
      matches.each do |username, displayname|
        source = Regexp.escape("[[@#{username} #{ERB::Util.html_escape(displayname)}]]")
        msg.gsub!(/#{source}/, format_link(username, displayname, url_opts, html_opts))
      end
    end

    username_matches = msg.scan(Mention::NameOrPlayerPattern)
    if username_matches
      username_matches = username_matches.flatten
      msg = ERB::Util.html_escape(msg) unless matches
      username_matches.each do |username|
        at_name = Regexp.escape("@#{username}")
        if username.include?("#")
          msg.gsub!(/#{at_name}\b/, format_playername_link(username, url_opts, html_opts))
        else
          msg.gsub!(/#{at_name}\b/, format_username_link(username, url_opts, html_opts))
        end
      end
    end
    msg
  end
end
