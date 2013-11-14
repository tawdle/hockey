class Penalty < ActiveRecord::Base
  state_machine :initial => :created do
    event :start do
      transition [:created, :paused] => :running, :if => :timed_penalty?
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
    after_transition any => :running, :do => [:set_timer_offset, :start_timer]
    after_transition any => :paused, :do => :pause_timer
    after_transition any - :created => [:canceled, :completed], :do => [:destroy_timer, :update_running_penalties]
  end

  belongs_to :game, :inverse_of => :penalties
  belongs_to :player
  belongs_to :serving_player, :class_name => "Player"
  belongs_to :timer

  before_validation :set_minutes_from_category
  after_commit :broadcast_changes
  after_destroy :update_running_penalties
  after_destroy :broadcast_changes

  attr_accessible :state, :player_id, :serving_player_id, :period, :category, :game, :elapsed_time, :infraction, :minutes, :action

  Codes = {
    # From http://www.hockeyestrie.qc.ca/documents/517-codification-des-punitions-anglais-2013-2014-couleur-1.pdf

    minor:              # A
    {
      minutes: 2,
      infractions: {
        aggressor: "A1",
        instigator: "A4",
        first_player_leaving_bench_to_fight: "A8",
        goalkeeper_leaving_crease_to_fight: "A9",
        grabbing_hair_without_advantage: "A10",
        slashing: "A22",
        spearing: "A23",
        butt_ending: "A24",
        cross_checking: "A25",
        high_sticking: "A26",
        charging: "A31",
        elbowing: "A34",
        kneeing: "A35",
        head_butting: "A37",
        illegal_body_check: "A39",
        checking_from_behind: "A40",
        boarding: "A44",
        roughing: "A47",
        head_contact: "A48",
        holding: "A50",
        holding_the_stick: "A51",
        hooking: "A52",
        tripping: "A53",
        interference: "A54",
        interference_from_bench: "A55",
        interference_with_goaltender: "A56",
        verbal_abuse: "A61",
        team_unsportsmanlike_conduct: "A63",
        abusive_language: "A70",
        too_many_players_on_ice: "A80",
        playing_with_broken_stick: "A81",
        unsustained_request_for_equipment_measurement: "A82",
        refusing_to_have_equipment_measured: "A83",
        playing_without_protective_equipment: "A84",
        wearing_non_certified_equipment: "A85",
        bench_minor_or_team_penalty: "A87",
        kick_shot: "A89",
        leaving_penalty_box: "A90",
        throwing_stick: "A91",
        delaying_game: "A92",
        moving_goal: "A93",
        illegal_face_off: "A95",
        closing_hand_on_puck: "A96",
        leaving_bench_at_end_of_period: "A98",
      }
    },
    major:              # B
    {
      minutes: 5,
      infractions: {
        fighting: "B2",
        fighting_single_player: "B3",
        grabbing_hair_without_advantage: "B10",
        grabbing_hair_with_advantage: "B11",
        use_of_mask_as_weapon: "B12",
        using_rings_as_weapons: "B13",
        slashing: "B22",
        spearing: "B23",
        butt_ending: "B24",
        cross_checking: "B25",
        high_sticking: "B26",
        charging: "B31",
        attempting_to_injure: "B32",
        elbowing: "B34",
        kneeing: "B35",
        kicking: "B36",
        head_butting: "B37",
        illegal_body_check: "B39",
        checking_from_behind: "B40",
        boarding: "B44",
        roughing: "B47",
        head_contact: "B48",
        holding: "B50",
        hooking: "B52",
        tripping: "B53",
        interference: "B54",
        interference_with_goaltender: "B56",
        diving: "B61",
        threatening_an_official: "B77",
        physical_aggression_against_official: "B78",
        spitting: "B79",
        kick_shot: "B89",
        refusing_to_start_play: "B97",
      }
    },
    misconduct:         # C
    {
      minutes: 10,
      infractions: {
        remaining_at_site_of_fight: "C5",
        verbal_abuse: "C61",
        abusive_language: "C70",
        not_going_to_penalty_box: "C72",
        inciting_an_opponent: "C76",
        refusing_to_have_equipment_measured: "C83",
        playing_without_protective_equipment: "C84",
        wearing_equipment_in_non_regulatory_fashion: "C86",
        throwing_stick: "C91",
      }
    },
    game_misconduct:    # D
    {
      minutes: nil,
      infractions: {
        fighting: "D2",
        fighting_single_player: "D3",
        second_fight: "D6",
        third_player_entering_fight: "D7",
        first_player_leaving_bench_to_fight: "D8",
        grabbing_hair_without_advantage: "D10",
        removing_helmet_to_fight: "D14",
        slashing: "D22",
        spearing: "D23",
        butt_ending: "D24",
        cross_checking: "D25",
        high_sticking: "D26",
        charging: "D31",
        elbowing: "D34",
        kneeing: "D35",
        head_butting: "D37",
        illegal_body_check: "D39",
        checking_from_behind: "D40",
        boarding: "D44",
        roughing: "D47",
        head_contact: "D48",
        holding: "D50",
        hooking: "D52",
        tripping: "D53",
        interference: "D54",
        interference_from_bench: "D55",
        interference_with_goaltender: "D56",
        verbal_abuse: "D61",
        verbal_discrimination: "D62",
        team_unsportsmanlike_conduct: "D63",
        gross_misconduct_travesty: "D66",
        abusive_language: "D70",
        second_misconduct_penalty: "D88",
        kick_shot: "D89",
        refusing_to_start_play: "D97",
        leaving_bench_at_end_of_period: "D98",
      }
    },
    match:              # E
    {
      minutes: nil,
      infractions: {
        grabbing_hair_with_advantage: "E11",
        use_of_mask_as_weapon: "E12",
        using_rings_as_weapons: "E13",
        slashing: "E22",
        spearing: "E23",
        butt_ending: "E24",
        cross_checking: "E25",
        high_sticking: "E26",
        attempting_to_injure: "B32",
        kicking: "B36",
        head_butting: "E37",
        checking_from_behind: "E40",
        head_contact: "E48",
        threatening_an_official: "E77",
        physical_aggression_against_official: "E78",
        spitting: "E79",
      }
    },
    penalty_shot:       # F
    {
      minutes: nil,
      infractions: {
        tripping: "F53",
        interference: "F54",
        interference_from_bench: "F55",
        too_many_players_on_ice: "F80",
        leaving_penalty_box: "F90",
        throwing_stick: "F91",
        delaying_game: "F92",
        moving_goal: "F93",
        moving_goal_during_breakaway: "F94",
        closing_hand_on_puck: "F96",
        refusing_to_start_play: "F97",
      }
    }
  }

  symbolize :category, :in => Codes.keys
  symbolize :infraction

  validates_presence_of :game
  validates_presence_of :player
  validate :infraction_in_list
  validate :player_in_game
  validate :serving_player_in_game
  validate :serving_player_on_same_team
  validates_numericality_of :period, :integer => true, :greater_than_or_equal_to => 0, :less_than => Game::Periods.length
  validates_numericality_of :elapsed_time, :greater_than_or_equal_to => 0
  validates_numericality_of :minutes, :integer => true, :greater_than => 0, :allow_nil => true

  default_scope order("id asc");
  scope :for_team, lambda {|team| joins(:player).where(:players => {:team_id => team.id }) }
  scope :timed, where("penalties.minutes is not null");
  scope :running, where(:state => :running)
  scope :paused, where(:state => :paused)
  scope :started, where(:state => [:running, :paused])
  scope :current, timed.where(:state => [:created, :running, :paused])
  scope :expired, timed.where(:state => [:canceled, :completed])
  scope :pending, timed.where(:state => :created)
  scope :others, where("penalties.minutes is null")
  scope :finished, where(:state => [:completed, :canceled])
  scope :eldest_siblings, timed.joins("left outer join penalties as others on others.id < penalties.id and penalties.game_id = others.game_id and penalties.player_id = others.player_id and others.state in ('created', 'running', 'paused')").where(:others => {:id => nil })


  def siblings
    Penalty.timed.current.where(:game_id => game_id, :player_id => player_id).where("id <> ?", id)
  end

  def younger_siblings
    siblings.where("id > ?", id)
  end

  def timed_penalty?
    !minutes.nil?
  end

  def timer_expired(timer_id)
    expire!
  end

  def action=(value)
    self.send("#{value}") if state_transitions.collect(&:event).map(&:to_s).include?(value)
  end

  private

  def set_minutes_from_category
    self.minutes ||= Codes[category].try(:[], :minutes)
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
    errors.add(:infraction, "not in list of infractions") unless category.nil? || Codes[category].nil? || Codes[category][:infractions].include?(infraction)
  end

  def init_timer
    create_timer(:duration => minutes.minutes, :owner => self)
    save!
  end

  def set_timer_offset
    timer.offset = younger_siblings.sum(:minutes).minutes
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

  def update_running_penalties
    Penalty.start_eligible_penalties(game) if game.playing?
  end

  MaxConcurrentPenalties = 2

  def self.start_eligible_penalties(game)
    start_paused_penalties(game)
    start_pending_penalties(game)
  end

  def self.pause_running_penalties(game)
    pause_running_penalties(game)
  end

  def self.start_pending_penalties(game)
    game.teams.each do |team|
      available = [MaxConcurrentPenalties - game.penalties.for_team(team).started.count,
                   game.penalties.for_team(team).pending.count].min
      if available > 0
        game.penalties.for_team(team).pending.eldest_siblings.limit(available).readonly(false).each do |penalty|
          penalty.start!
        end
      end
    end
  end

  def self.pause_running_penalties(game)
    game.penalties.running.each do |penalty|
      penalty.pause!
    end
  end

  def self.start_paused_penalties(game)
    game.penalties.paused.each do |penalty|
      penalty.start!
    end
  end

end
