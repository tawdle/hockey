class Locations::ScoreboardsController < ApplicationController
  load_and_authorize_resource :location

  before_filter :load_game

  def show
    render :layout => "scoreboard"
  end


  private

  def load_game
    @game = @location.current_game
  end
end
