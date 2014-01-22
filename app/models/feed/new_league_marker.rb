class Feed::NewLeagueMarker < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"
  belongs_to :league, foreign_key: "target_id"

  attr_accessible :user, :league

  validates_presence_of :user
  validates_presence_of :league

  def message
    I18n.t "feed.new_league_manager", user: user.at_name, league: league.at_name
  end

  def mentioned_objects
    [user, league]
  end
end
