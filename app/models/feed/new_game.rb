class Feed::NewGame < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"

  attr_accessible :user, :league

  validates_presence_of :user
  validates_presence_of :game

  def message
    I18n.t "feed.new_game", user: user.feed_name, visiting_team: game.visiting_team.feed_name, home_team: game.home_team.feed_name
  end

  def mentioned_objects
    [user, game.visiting_team, game.home_team, game.league]
  end
end

