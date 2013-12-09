class Goal < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game, :inverse_of => :goals
  belongs_to :team
  has_many :goal_players, :order => "ordinal asc"
  has_many :players, :through => :goal_players, :order => "goal_players.ordinal asc"

  attr_accessor :updater
  attr_accessible :game, :game_id, :creator, :team_id, :period, :player_ids, :elapsed_time, :advantage


  validates_presence_of :creator
  validates_presence_of :game
  validates_presence_of :team
  validate :team_is_in_game
  validates_numericality_of :period, :integer => true, :less_than_or_equal_to => Game::Periods.length, :greater_than_or_equal_to => 0
  validate :game_has_started

  after_initialize :set_players_was_empty
  before_validation :set_time_and_period_from_game
  before_validation :set_advantage

  after_create :goal_created
  after_save :complete_goal_saved, :if => :players_just_added
  after_destroy :goal_destroyed

  scope :for_team, lambda {|team| where(:team_id => team.id) }

  Advantages = {
    -2 => :three_on_five,
    -1 => :four_on_five,
     0 => :even,
    +1 => :five_on_four,
    +2 => :five_on_three
  }

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

  def players_just_added
    @players_was_empty && !players_empty?
  end

  def complete_goal_saved
    game.batch_broadcasts do
      broadcast_changes
      cancel_minor_penalty
      generate_save_feed_item
    end
  end

  def goal_created
    game.batch_broadcasts do
      stop_clock
      broadcast_changes
    end
  end

  def goal_destroyed
    game.batch_broadcasts do
      generate_destroy_feed_item unless players_empty?
      broadcast_changes
    end
  end

  def cancel_minor_penalty
    Penalty.goal_scored(game, team)
  end

  def updater_name
    updater.try(:at_name) || "The System"
  end

  def generate_save_feed_item
    message = "#{player.feed_name} scored a goal for #{team.at_name} against #{game.opposing_team(team).at_name}"
    if assisting_players.any?
      message << ", assisted by "
      message << assisting_players.collect(&:feed_name).join(" and ")
    end
    game.activity_feed_items.create!(:message => message, :game => game)
  end

  def generate_destroy_feed_item
    message = "#{updater_name} revoked #{player.feed_name}'s goal against #{game.opposing_team(team).at_name}"
    game.activity_feed_items.create!(:message => message)
  end

  def team_is_in_game
    errors.add(:team, "must be playing in game") unless team.nil? || game.nil? || team == game.home_team || team == game.visiting_team
  end

  def players_are_on_team
    errors.add(:players, "must be on team") unless player.empty? || team.nil? || players.all? {|player| team.players.include?(player) }
  end

  def game_has_started
    errors.add(:game, "must have started") unless game.nil? || !game.scheduled?
  end

  def set_time_and_period_from_game
    if game
      self.period ||= game.period
      self.elapsed_time ||= game.elapsed_time
    end
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => [:goals])
  end

  def stop_clock
    game.pause # If we're already stopped, this is a no-op
  end

  def set_players_was_empty
    @players_was_empty = players_empty?
  end

  def set_advantage
    self.advantage ||= (Penalty.players_off_ice(game, game.opposing_team(team)) - Penalty.players_off_ice(game, team)) if game && team
  end
end
