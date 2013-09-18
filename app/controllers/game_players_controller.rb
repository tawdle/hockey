class GamePlayersController < ApplicationController
  load_and_authorize_resource :game
  before_filter :load_home_or_visiting
  before_filter :load_team

  # There's probably a better pattern than what we're doing here.
  # #new and #create support the creation of new players. #edit and #update manage
  # the game roster.

  def show
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(params[:player].merge(:team => @team))

    respond_to do |format|
      if @player.save && @game.players << @player
        format.html { redirect_to edit_game_roster_path(@game, :team => @home_or_visiting), notice: 'Player was successfully added.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

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