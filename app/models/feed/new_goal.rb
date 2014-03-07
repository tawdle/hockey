class Feed::NewGoal < ActivityFeedItem
  belongs_to :player
  belongs_to :player2, class_name: "Player"
  belongs_to :player3, class_name: "Player"

  attr_accessible :game, :player, :player2, :player3

  validates_presence_of :player
  validates_presence_of :game

  def message
    opts = {
      player: player.feed_name,
      assist1: player2.try(:feed_name),
      assist2: player3.try(:feed_name),
      for_team: player.team.feed_name,
      against_team: game.opposing_team(player.team).feed_name
    }
    msg = player3 ? "two_assists" : player2 ? "one_assist" : "solo"
    I18n.t "feed.new_goal.#{msg}", opts
  end

  def mentioned_objects
    [player, player2, player3].compact
  end
end


