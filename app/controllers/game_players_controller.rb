class GamePlayersController < ApplicationController
  load_and_authorize_resource :game
  before_filter :load_home_or_visiting
  before_filter :load_team

  def edit
  end

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game roster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_home_or_visiting
    @home_or_visiting = params[:team] == "visiting" ? "visiting" : "home"
  end

  def load_team
    @team = @game.send("#{@home_or_visiting}_team")
    @other_team = @game.opposing_team(@team)
  end
end
