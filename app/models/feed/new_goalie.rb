class Feed::NewGoalie < ActivityFeedItem
  belongs_to :player

  attr_accessible :game, :player

  validates_presence_of :player
  validates_presence_of :game

  def message
    I18n.t "feed.new_goalie", player: player.at_name, team: player.team.at_name
  end

  def mentioned_objects
    [player]
  end
end



