class Locations::ScoreboardsController < ApplicationController
  load_and_authorize_resource :location

  layout "scoreboard"

  def show
    authorize! :view_scoreboard, @location
    @game = @location.game_for_scoreboard

    if @game
      render
    else
      render "no_game"
    end
  end
end
