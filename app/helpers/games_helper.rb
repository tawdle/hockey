module GamesHelper
  def checklist_item(method, text, link)
    if @game.send(method)
      "<li><i class='icon-check text-success'></i> #{ link_to text, link }".html_safe
    else
      "<li><span class='text-error' style='margin-left: 0px; margin-right: 2px;'>&#10006;</span> <b>#{ link_to text, link }</b>".html_safe
    end
  end

  def edit_game_path(game)
    if game.nil? || game.league.nil?
      nil
    elsif game.league.is_a?(Tournament)
      edit_tournament_game_path(game.league, game)
    else
      edit_league_game_path(game.league, game)
    end
  end
end
