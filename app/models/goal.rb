class Goal < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game
  belongs_to :team
  has_many :goal_players, :order => "ordinal asc"
  has_many :players, :through => :goal_players

  attr_accessor :updater
  attr_accessible :game, :game_id, :creator, :team_id, :period

  validates_inclusion_of :period, :in => Game::Periods

  validates_presence_of :creator
  validates_presence_of :game
  validates_presence_of :team
  validate :team_is_in_game

  before_save :generate_save_feed_item, :unless => :players_empty?
  before_destroy :generate_destroy_feed_item, :unless => :players_empty?

  scope :for_team, lambda {|team| where(:team_id => team.id) }

  def player
    players.first
  end

  def assisting_players
    players[1..-1]
  end

  def players_empty?
    players.empty?
  end

  private

  def updater_name
    updater.try(:at_name) || "The System"
  end

  def generate_save_feed_item
    message = "#{player.at_name} scored a goal for #{team.at_name} against #{game.opposing_team(team).at_name}"
    if assisting_players.any?
      message << ", assisted by "
      message << assisting_players.collect(&:at_name).join(" and ")
    end
    game.activity_feed_items.create!(:message => message)
  end

  def generate_destroy_feed_item
    message = "#{updater_name} revoked #{player.at_name}'s goal against #{game.opposing_team(team).at_name}"
    game.activity_feed_items.create!(:message => message)
  end

  def team_is_in_game
    errors.add(:team, "must be playing in game") unless team.nil? || game.nil? || team == game.home_team || team == game.visiting_team
  end

  def players_are_on_team
    errors.add(:players, "must be on team") unless player.empty? || team.nil? || players.all? {|player| team.players.include?(player) }
  end
end
