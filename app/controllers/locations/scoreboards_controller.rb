class Locations::ScoreboardsController < ApplicationController
  load_and_authorize_resource :location

  def show
    authorize! :view_scoreboard, @location
    @game = @location.game_for_scoreboard

    if @game
      render :layout => "scoreboard"
    else
      render :template => "no_game"
    end
  end
end
