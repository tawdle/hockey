class Feed::NewTeamManager < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"
  belongs_to :team, foreign_key: "target_id"

  attr_accessible :user, :team

  validates_presence_of :user
  validates_presence_of :team

  def message
    I18n.t "feed.new_team_manager", user: user.at_name, team: team.at_name
  end

  def mentioned_objects
    [user, team]
  end
end
