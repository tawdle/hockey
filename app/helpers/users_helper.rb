module UsersHelper
  include Rails.application.routes.url_helpers

  def format_user_link(user)
    "<span class='username'>@#{link_to(user.name, user.nameable || user)}</span>".html_safe if user
  end

  def format_player_link(player)
    "<span class='username'>@#{link_to("#{player.team.name}##{player.jersey_number}", player)}</span>".html_safe if player
  end

  def format_message_with_usernames(msg)
    username_matches = msg.scan(/\@([a-zA-Z0-9_]*(?:#[0-9]+)?)/)
      if username_matches
        username_matches = username_matches.flatten
        msg = msg.clone
        usernames = username_matches.reject {|u| u.include?("#") }
        playernames = username_matches.select {|u| u.include?("#") }
        playernames.each do |playername|
          team_name, jersey_number = playername.split("#")
          team = Team.find_by_name(team_name)
          if team
            player = Player.find_by_jersey_number_and_team_id(jersey_number, team.id)
            msg.gsub!("@#{playername}", format_player_link(player)) if player
          end
        end
        if usernames
          User.where(:name => usernames).each do |user|
            msg.gsub!("@#{user.name}", format_user_link(user))
          end
        end
      end
    msg
  end
end
