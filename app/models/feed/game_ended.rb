class Feed::GameEnded < ActivityFeedItem
  validates_presence_of :game

  attr_accessible :game

  def message
    if game.home_team_score > game.visiting_team_score
      first_team = game.home_team.at_name
      first_score = game.home_team_score
      second_team = game.visting_team.at_name
      second_score = game.visting_team.at_name
    else
      first_team = game.visiting_team.at_name
      first_score = game.visiting_team_score
      second_team = game.home_team.at_name
      second_score = game.home_team.at_name
    end

    I18n.t "feed.game_ended",
      first_team: first_team, first_team_score: first_score,
      second_team: second_team, second_team_score: second_score
  end

  def mentioned_objects
    [game.home_team, game.visiting_team]
  end
end


