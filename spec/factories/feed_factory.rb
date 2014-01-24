require 'factory_girl'

FactoryGirl.define do
  factory :cancel_game, class: Feed::CancelGame do
    user
    game
  end

  factory :cancel_goal, class: Feed::CancelGoal do
    user
    game
    player
  end

  factory :change_game_location, class: Feed::ChangeGameLocation do
    user
    game
  end

  factory :change_game_time, class: Feed::ChangeGameTime do
    user
    game
  end

  factory :game_ended, class: Feed::GameEnded do
    game
  end

  factory :game_started, class: Feed::GameStarted do
    game
  end

  factory :new_following, class: Feed::NewFollowing do
    user
    target { build(:player) }
  end

  factory :new_game, class: Feed::NewGame do
    user
    game
  end

  factory :new_goalie, class: Feed::NewGoalie do
    player
    game
  end

  factory :new_goal, class: Feed::NewGoal do
    player
    game
  end

  factory :new_league_manager, class: Feed::NewLeagueManager do
    user
    league
  end

  factory :new_league_marker, class: Feed::NewLeagueMarker do
    user
    league
  end

  factory :new_location_manager, class: Feed::NewLocationManager do
    user
    location
  end

  factory :new_penalty, class: Feed::NewPenalty do
    game
    player
    penalty
  end

  factory :new_team_manager, class: Feed::NewTeamManager do
    user
    team
  end

  factory :new_user, class: Feed::NewUser do
    user
  end
end


