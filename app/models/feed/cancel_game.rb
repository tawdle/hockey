class Feed::CancelGame < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"

  attr_accessible :user

  validates_presence_of :user
  validates_presence_of :game

  def mentioned_objects
    [user]
  end

  def message
    I18n.t "feed.cancel_game", user: user.at_name, visiting_team: game.visiting_team.at_name, home_team: game.home_team.at_name
  end
end
