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
    save!
  end

  def current?
    persisted? && end_time.nil? && end_period.nil?
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