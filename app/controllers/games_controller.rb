class GamesController < ApplicationController
  load_and_authorize_resource :league

  def new
    @game = Game.new(:home_team => @league.teams.first, :visiting_team => @league.teams.second)
    authorize! :new, @game
  end

  def create
    @game = Game.new(params[:game])
    authorize! :create, @game

    respond_to do |format|
      if @game.save
        format.html { redirect_to league_path(@league), notice: 'Game was successfully scheduled.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
