class GamePlayer < ActiveRecord::Base
  belongs_to :game, :inverse_of => :game_players
  belongs_to :player

  validates_presence_of :game
  validates_presence_of :player
  validates_uniqueness_of :player_id, :scope => :game_id
  validate :player_on_team

  private

  def player_on_team
    errors.add(:player, "must be on home team or visiting team") unless game.nil? || player.nil? || player.team_id == game.home_team_id || player.team_id == game.visiting_team_id
  end
end
