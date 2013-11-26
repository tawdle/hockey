class GameGoalie < ActiveRecord::Base
  belongs_to :game
  belongs_to :goalie, :class_name => "Player"

  validates_presence_of :game
  validates_presence_of :goalie

  before_validation :set_start_time_and_period
  before_create :end_previous_game_goalie

  scope :for_team, lambda {|team| joins(:goalie).where(:players => {:team_id => team.id }) }
  scope :current, where(:end_time => nil, :end_period => nil )

  attr_accessible :end_time, :end_period, :goalie_id

  after_create :create_feed_item

  def finish!
    set_end_time_and_period
    if minutes_played == 0
      self.destroy
    else
      save!
    end
    game.send(:broadcast_changes) if game
  end

  def current?
    persisted? && end_time.nil? && end_period.nil?
  end

  def period_time(period, time, otherwise)
    return otherwise unless period && time
    (period || 0) * 1_000_000 + (time || 0)
  end

  FixnumMax = (2**(0.size * 8 - 2) - 1)
  FixnumMin = -(2**(0.size * 8 - 2))

  def goals
    Goal.where(:game_id => game_id).for_team(game.opposing_team(goalie.team)).
      where("goals.period * 1000000 + goals.elapsed_time between ? and ?",
            period_time(start_period, start_time, FixnumMin), period_time(end_period, end_time, FixnumMax))
  end

  def minutes_played
    return 0 unless end_period && end_time
    ((end_period - start_period) * game.period_duration + (end_time - start_time)) / 60.0
  end

  private

  def set_start_time_and_period
    if game
      self.start_time ||= (game.elapsed_time || 0)
      self.start_period ||= (game.period || 0)
    end
  end

  def set_end_time_and_period
    if game
      self.end_time = (game.elapsed_time || 0)
      self.end_period = (game.period || 0)
    end
  end

  def end_previous_game_goalie
    game.game_goalies.for_team(goalie.team).current.readonly(false).each do |game_goalie|
      game_goalie.finish!
    end
  end

  def create_feed_item
    game.activity_feed_items.create!(:message => "#{goalie.feed_name} is now the goalie for #{goalie.team.at_name}")
  end
end
