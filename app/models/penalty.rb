class Penalty < ActiveRecord::Base
  state_machine :initial => :created do
    event :start do
      transition [:created, :paused] => :running
    end

    event :pause do
      transition :running => :paused
    end

    event :expire do
      transition :running => :completed
    end

    event :terminate do
      transition any => :completed
    end

    event :cancel do
      transition any => :canceled
    end

    after_transition :created => :running, :do => :init_timer
    after_transition any => :running, :do => :start_timer
    after_transition any => :paused, :do => :pause_timer
    after_transition any => :completed, :do => :destroy_timer
    after_transition any - :created => :canceled, :do => :destroy_timer
    after_transition any => :running, :do => :pause!, :unless => :game_playing?
  end

  belongs_to :game, :inverse_of => :penalties
  belongs_to :player
  belongs_to :serving_player, :class_name => "Player"
  belongs_to :timer

  before_validation :set_minutes_from_category
  after_commit :broadcast_changes
  after_destroy :broadcast_changes

  attr_accessible :state, :player_id, :serving_player_id, :period, :category, :game, :elapsed_time, :infraction, :minutes, :action

  Infractions = {
    :minor => [
      :boarding,
      :broken_stick,
      :charging,
      :clipping,
      :closing_hand_on_puck,
      :cross_checking,
      :delay_of_game,
      :elbowing,
      :goalkeeper_interference,
      :high_sticking,
      :holding,
      :holding_the_stick,
      :hooking,
      :illegal_equipment,
      :illegal_stick,
      :instigator,
      :interference,
      :kneeing,
      :leaving_penalty_bench_early,
      :leaving_the_crease,
      :participating_in_the_play_beyond_the_red_line,
      :roughing,
      :slashing,
      :throwing_puck_toward_opponents_goal,
      :throwing_stick,
      :tripping,
      :unsportsmanlike_conduct
    ],
    :bench_minor => [
      :abuse_of_officials,
      :delay_of_game,
      :deliberate_illegal_substitution,
      :face_off_violation,
      :illegal_substitution,
      :improper_starting_line_up,
      :interference_from_players_or_penalty_bench,
      :interference_with_an_official,
      :leaving_bench_at_end_of_period,
      :refusing_to_start_play,
      :stepping_onto_ice_during_period,
      :throwing_objects_onto_ice,
      :too_many_men_on_the_ice,
      :unsportsmanlike_conduct,
      :unsustained_request_for_measurement
    ],
    :double_minor => [
      :butt_ending,
      :head_butting,
      :high_sticking,
      :spearing
    ],
    :major => [
      :boarding,
      :butt_ending,
      :charging,
      :checking_from_behind,
      :clipping,
      :cross_checking,
      :elbowing,
      :fighting,
      :head_butting,
      :hooking,
      :illegal_check_to_the_head,
      :interference,
      :kneeing,
      :slashing,
      :spearing
    ]
  }

  symbolize :category, :in => Infractions.keys
  symbolize :infraction

  validates_presence_of :game
  validates_presence_of :player
  validate :infraction_in_list
  validate :player_in_game
  validate :serving_player_in_game
  validate :serving_player_on_same_team
  validates_numericality_of :period, :integer => true, :greater_than_or_equal_to => 0, :less_than => Game::Periods.length
  validates_numericality_of :elapsed_time, :greater_than_or_equal_to => 0
  validates_numericality_of :minutes, :integer => true, :greater_than => 0

  scope :running, where(:state => :running)
  scope :paused, where(:state => :paused)

  def timer_expired(timer_id)
    expire!
  end

  def action=(value)
    self.send("#{value}") if state_transitions.collect(&:event).map(&:to_s).include?(value)
  end

  private

  def set_minutes_from_category
    self.minutes ||= { minor: 2, bench_minor: 2, major: 5, double_minor: 10 }[category]
  end

  def game_playing?
    game.playing?
  end

  def player_in_game
    errors.add(:player, "must be in game") unless game.nil? || player.nil? || game.players.include?(player)
  end

  def serving_player_in_game
    errors.add(:serving_player, "must be in game") unless game.nil? || serving_player.nil? || game.players.include?(serving_player)
  end

  def serving_player_on_same_team
    errors.add(:serving_player, "must be on same team") unless player.nil? || serving_player.nil? || player.team == serving_player.team
  end

  def infraction_in_list
    errors.add(:infraction, "not in list of infractions") unless category.nil? || Infractions[category].nil? || Infractions[category].include?(infraction)
  end

  def init_timer
    self.timer = Timer.create(:duration => minutes.minutes, :owner => self)
  end

  def start_timer
    timer.start!
  end

  def pause_timer
    timer.pause!
  end

  def destroy_timer
    timer.destroy
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => :penalties)
  end
end
