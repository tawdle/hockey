class Feed::NewPlayerClaim < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"
  belongs_to :player

  attr_accessible :user, :player

  validates_presence_of :user
  validates_presence_of :player

  def message
    I18n.t "feed.new_player_claim", user: user.feed_name, player: player.team_feed_name
  end

  def mentioned_objects
    [user, player, player.team]
  end
end


