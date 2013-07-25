class Goal < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game
  belongs_to :team
  belongs_to :player, :class_name => "User"
  belongs_to :assisting_player, :class_name => "User"

  attr_accessible :game, :game_id, :creator, :team_id, :player_id, :assisting_player_id, :period

  validates_inclusion_of :period, :in => Game::Periods

  validates_presence_of :creator
  validates_presence_of :game
  validates_presence_of :team
  validates_presence_of :player
  validate :team_is_in_game
  validate :player_is_on_team
  validate :assisting_player_is_on_team
  validate :assisting_player_is_different

  before_create :generate_feed_item

  scope :for_team, lambda {|team| where(:team_id => team.id) }

  private

  def generate_feed_item
    message = "@#{player.name} scored a goal for @#{team.name} against @#{game.opposing_team(team).name}"
    message << ", assisted by @#{assisting_player.name}" if assisting_player
    game.activity_feed_items.create!(:message => message)
  end

  def team_is_in_game
    errors.add(:team, "must be playing in game") unless team.nil? || game.nil? || team == game.home_team || game.visiting_team
  end

  def player_is_on_team
    errors.add(:player, "must be on team") unless player.nil? || team.nil? || team.players.include?(player)
  end

  def assisting_player_is_on_team
    errors.add(:assisting_player, "must be on team") unless assisting_player.nil? || team.nil? || team.players.include?(assisting_player)
  end

  def assisting_player_is_different
    errors.add(:assisting_player, "cannot be the same as player") unless assisting_player.nil? || player.nil? || assisting_player != player
  end
end
