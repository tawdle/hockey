class Marker::GameGoaliesController < ApplicationController
  load_and_authorize_resource :game
  before_filter :load_team

  def new
    @game_goalie = @game.game_goalies.build
    authorize! :create, @game_goalie
    render :layout => !request.xhr?
  end

  def create
    @game_goalie = @game.game_goalies.build(params[:game_goalie])
    authorize! :create, @game_goalie

    if @game_goalie.goalie_id == 0
      @game.game_goalies.for_team(@team).current.readonly(false).each {|gg| gg.finish! }
      respond_to do |format|
        format.html { redirect_to @game, notice: 'Goalie was successfully pulled.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        if @game_goalie.save
          format.html { redirect_to @game, notice: 'Goalie was successfully changed.' }
          format.json { render json: @game, status: :created, location: @game }
        else
          format.html { render action: "new" }
          format.json { render json: @game_goalie.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def load_team
    @team = params[:team] == "visiting" ? @game.visiting_team : @game.home_team
  end
end
