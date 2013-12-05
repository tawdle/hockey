require "prawn"

class Gamesheets::HockeyQuebec < Prawn::Document
  def initialize(options={}, &block)
    @game = options.delete(:game)
    super(options.merge(
      template: Rails.root.join("lib", "pdf", "gamesheet-hockey-quebec.pdf"),
      left_margin: 27,
      bottom_margin: 20,
      top_margin: 20,
      right_margin: 27
    ))
  end

  def draw_goalies(team, x)
    goalies = @game.game_players.for_team(team).goalies.limit(2).map(&:player)
    translate(x, 558) do
      goalies.each_with_index do |goalie, index|
        translate(0, -index * 18) do
          draw_text(goalie.jersey_number, at: [0, 0])
          draw_text(goalie.name, at: [15, 0])
        end
      end
    end
  end

  RoleMap = {:player => "", :captain => "C", :assistant_captain => "A", :goalie => "G" }

  def draw_players(team, x)
    game_players = @game.game_players.for_team(team).nongoalies.limit(19)
    translate(x, 520) do
      game_players.each_with_index do |game_player, index|
        player = game_player.player
        translate(0, -index * 18) do
          draw_text(player.jersey_number, at: [0, 0])
          draw_text(player.name, at: [15, 0])
          draw_text(RoleMap[game_player.role], at: [186, 0])
        end
      end
    end
  end

  def draw_goals(team, x)
    goals = @game.goals.for_team(team).limit(23)
    translate(x, 538) do
      goals.each_with_index do |goal, index|
        translate(0, -index * 18) do
          goal.players.each_with_index do |player, h_index|
            translate(16 * h_index, 0) do
              draw_text(player.jersey_number, at: [0, 0])
            end
          end
          text_box(Timer.to_hms(goal.elapsed_time), at: [45, 7], height: 10, width: 40, align: :right)
          text_box(Game::Periods[goal.period], at: [90, 7], height: 10, width: 10, align: :center)
        end
      end
    end
  end

  def draw_these_penalties(penalties, x)
    translate(x, 430) do
      penalties.each_with_index do |penalty, index|
        translate(0, -index * 18) do
          case penalty.penalizable_type
          when "Player"
            draw_text(penalty.penalizable.jersey_number, at: [1, 0])
            if penalty.serving_player
              font_size 6 do
                fill_color "FFFFFF"
                fill_and_stroke_circle [-1, 12], 6
                fill_color "000000"
                draw_text(penalty.serving_player.jersey_number, at: [-4.5, 10])
              end
            end
          when "StaffMember"
            role = @game.game_staff_members.where(:staff_member_id => penalty.penalizable_id).first.role
            draw_text(I18n.t(role, scope: "activerecord.values.staff_member.role.abbreviations"), at: [1, 0])
          when "Team"
            if penalty.serving_player
              fill_color "FFFFFF"
              fill_and_stroke_circle [6, 5], 8
              fill_color "000000"
              draw_text(penalty.serving_player.jersey_number, at: [1, 2])
            end
          end
          draw_text(Penalty::Codes[penalty.category][:infractions][penalty.infraction], at: [22, 0])
          text_box(Timer.to_hms(penalty.elapsed_time), at: [45, 7], height: 10, width: 40, align: :right)
          text_box(Game::Periods[penalty.period], at: [88, 7], height: 10, width: 10, align: :center)
        end
      end
    end
  end

  def draw_penalties(team, x, flip=false)
    draw_these_penalties(@game.penalties.for_team(team).minor.limit(20), flip ? x + 101  : x)
    draw_these_penalties(@game.penalties.for_team(team).nonminor.limit(20), flip ? x : x + 101)
  end

  def draw_staff_members(team, x)
    game_staff = @game.game_staff_members.for_team(team).limit(4)

    translate(x, 183) do
      game_staff.each_with_index do |gsm, index|
        translate(0, -index * 12) do
          draw_text("#{gsm.staff_member.name} (#{I18n.t(gsm.role, :scope => 'activerecord.values.staff_member.role')})", at: [0, 0])
        end
      end
    end
  end

  def draw_goalie_stats
    goalies = @game.game_goalies.for_team(@game.visiting_team).select("distinct goalie_id").limit(2).map(&:goalie)

    goalies.each_with_index do |goalie, index|
      translate(535, 110 - index * 18) do
        draw_text(goalie.jersey_number, at: [0, 0])
        [0, 1, 2, 3].each do |period|
          goals = @game.game_goalies.where(:goalie_id => goalie.id).map(&:goals).flatten.select {|g| g.period == period }.count
          translate(-26 - 50 * period, 0) do
            draw_text(goals, at: [0, 0])
          end
        end
        total = @game.game_goalies.where(:goalie_id => goalie.id).map(&:goals).flatten.count
        minutes_played = @game.game_goalies.where(:goalie_id => goalie.id).map(&:minutes_played).sum.round
        translate(-30 - 50 * 4, 0) do
          draw_text(total, at: [0, 0])
          draw_text(minutes_played, at: [-52, 0])
        end
      end
    end

    goalies = @game.game_goalies.for_team(@game.home_team).select("distinct goalie_id").limit(2).map(&:goalie)

    goalies.each_with_index do |goalie, index|
      translate(560, 110 - index * 18) do
        draw_text(goalie.jersey_number, at: [0, 0])
        [0, 1, 2, 3].each do |period|
          goals = @game.game_goalies.where(:goalie_id => goalie.id).map(&:goals).flatten.select {|g| g.period == period }.count
          translate(55 + 50 * period, 0) do
            draw_text(goals, at: [0, 0])
          end
        end
        total = @game.game_goalies.where(:goalie_id => goalie.id).map(&:goals).flatten.count
        minutes_played = @game.game_goalies.where(:goalie_id => goalie.id).map(&:minutes_played).sum.round
        translate(60 + 50 * 4, 0) do
          draw_text(total, at: [0, 0])
          draw_text(minutes_played, at: [30, 0])
        end
      end
    end
  end

  def to_pdf
    font_size 10

    translate(0, 611) do
      draw_text(@game.location.name, at: [65, 0])
      draw_text(@game.location.city, at: [255, 0])
      draw_text(@game.started_at.to_date, at: [430, 0])
      draw_text(I18n.t(@game.league.division, :scope => "league.divisions") , at: [539, 0])
      draw_text(I18n.t(@game.league.classification, :scope => "league.classifications"), at: [682, 0]) if @game.league.classification
      draw_text(@game.number, at: [775, 0])
      draw_text(@game.league.name, at: [840, 0])
    end

    translate(0, 594) do
      draw_text(@game.visiting_team.full_name, at: [310, 0])
      draw_text(@game.home_team.full_name, at: [575, 0])
    end

    draw_goalies(@game.visiting_team, 307)
    draw_goalies(@game.home_team, 507)

    draw_players(@game.visiting_team, 307)
    draw_players(@game.home_team, 507)

    draw_staff_members(@game.visiting_team, 307)
    draw_staff_members(@game.home_team, 507)

    draw_goals(@game.visiting_team, 203)
    draw_goals(@game.home_team, 708)

    draw_penalties(@game.visiting_team, 2)
    draw_penalties(@game.home_team, 810, true)

    font_size(20) do
      draw_text(@game.visiting_team_score, at: [168, 33])
      draw_text(@game.home_team_score, at: [878, 43])
    end

    draw_text(@game.started_at.to_s(:time), at: [780, 8])
    draw_text(@game.ended_at.to_s(:time), at: [817, 8])

    draw_goalie_stats

    ref = @game.game_officials.where(:role => :referee).first
    linesmen = @game.game_officials.where(:role => :linesman).limit(2)

    translate(566, 62) do
      draw_text(ref.official.name, at: [0, -3 * 15]) if ref
      draw_text(linesmen[0].official.name, at: [0, -2 * 15]) if linesmen[0]
      draw_text(linesmen[1].official.name, at: [0, -1 * 15]) if linesmen[1]
      draw_text(@game.marker.name, at: [0, 0]) if @game.marker
    end

    #stroke_axis

    render
  end

  # Draws and strokes X and Y axes rulers beginning at the current bounding
  # box origin (or at a custom location).
  #
  # == Options
  #
  # +:at+::
  #   Origin of the X and Y axes (default: [0, 0] = origin of the bounding
  #   box)
  #
  # +:width+::
  #   Length of the X axis (default: width of the bounding box)
  #
  # +:height+::
  #   Length of the Y axis (default: height of the bounding box)
  #
  # +:step_length+::
  #   Length of the step between markers (default: 100)
  #
  # +:negative_axes_length+::
  #   Length of the negative parts of the axes (default: 20)
  #
  # +:color+:
  #   The color of the axes and the text.
  #
  def stroke_axis(options = {})
    options = {
      :at => [0,0],
      :height => bounds.height.to_i - (options[:at] || [0,0])[1],
      :width => bounds.width.to_i - (options[:at] || [0,0])[0],
      :step_length => 100,
      :negative_axes_length => 20,
      :color => "000000",
    }.merge(options)

    Prawn.verify_options([:at, :width, :height, :step_length,
                          :negative_axes_length, :color], options)

    save_graphics_state do
      fill_color(options[:color])
      stroke_color(options[:color])

      dash(1, :space => 4)
      stroke_horizontal_line(options[:at][0] - options[:negative_axes_length],
                             options[:at][0] + options[:width], :at => options[:at][1])
      stroke_vertical_line(options[:at][1] - options[:negative_axes_length],
                           options[:at][1] + options[:height], :at => options[:at][0])
      undash

      fill_circle(options[:at], 1)

      (options[:step_length]..options[:width]).step(options[:step_length]) do |point|
        fill_circle([options[:at][0] + point, options[:at][1]], 1)
        draw_text(point, :at => [options[:at][0] + point - 5, options[:at][1] - 10], :size => 7)
      end

      (options[:step_length]..options[:height]).step(options[:step_length]) do |point|
        fill_circle([options[:at][0], options[:at][1] + point], 1)
        draw_text(point, :at => [options[:at][0] - 17, options[:at][1] + point - 2], :size => 7)
      end
    end
  end
end
