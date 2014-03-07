class Feed::GameStarted < ActivityFeedItem
  validates_presence_of :game

  attr_accessible :game

  def message
    I18n.t "feed.game_started", visiting_team: game.visiting_team.feed_name, home_team: game.home_team.feed_name, location: game.location.feed_name
  end

  def mentioned_objects
    [game.visiting_team, game.home_team]
  end
end



