class Feed::CancelGoal < ActivityFeedItem
  belongs_to :player
  belongs_to :user, foreign_key: "subject_id"

  attr_accessible :game, :user, :player

  validates_presence_of :player
  validates_presence_of :game
  validates_presence_of :user

  def mentioned_objects
    [user, player]
  end

  def message
    I18n.t "feed.cancel_goal", user: user.feed_name, player: player.feed_name
  end
end



