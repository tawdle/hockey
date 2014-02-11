
module Stats
  class Team
    attr_accessor :team, :games

    def initialize(team, games)
      self.team = team
      self.games = games.for_team(team).completed.includes(:goals, :penalties)
    end

    def game_ids
      games.map(&:id)
    end

    def games_played
      games
    end

    def victories
      games.select {|g| g.score_for(team) > g.score_for(g.opposing_team(team)) }
    end

    def overtime_victories
      victories.select {|g| g.period == 3 }
    end

    def shootout_victories
      victories.select {|g| g.period == 4 }
    end

    def defeats
      games.select {|g| g.score_for(team) < g.score_for(g.opposing_team(team)) }
    end

    def overtime_defeats
      defeats.select {|g| g.period == 3 }
    end

    def shootout_defeats
      defeats.select {|g| g.period == 4 }
    end

    def overtime_and_shootout_defeats
      overtime_defeats + shootout_defeats
    end

    def goals_scored
      Goal.where(:game_id => game_ids, :team_id => team.id)
    end

    def goals_yielded
      Goal.where(:game_id => game_ids).where("team_id <> ?", team.id)
    end

    def differential
      goals_scored.count - goals_yielded.count
    end

    def percentage
      scored = goals_scored.count
      yielded = goals_yielded.count
      scored + yielded == 0 ?
        Float::NAN :
        100.0 * scored / (scored + yielded)
    end

    def performance_points
      2 * victories.count + 1 * (overtime_defeats.count + shootout_defeats.count)
    end

    def franc_jeu_points
      games.map {|g| g.franc_jeu_points_for(team) }.sum
    end

    def points
      performance_points + franc_jeu_points
    end

    def penalties
      Penalty.where(:game_id => game_ids).for_team(team)
    end

    def penalty_minutes
      (penalties.map(&:minutes) || [0]).compact.sum
    end

    def ejections
      penalties.where(:category => [:misconduct, :game_misconduct, :match])
    end

    [:games_played, :victories, :overtime_victories, :shootout_victories,
     :defeats, :overtime_defeats, :shootout_defeats, :overtime_and_shootout_defeats,
     :goals_scored, :goals_yielded, :penalties, :ejections].each do |meth|
       define_method "num_#{meth}" do
         send(meth).count
       end
     end
  end
end
