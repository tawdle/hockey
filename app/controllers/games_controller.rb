class GamesController < ApplicationController
  load_and_authorize_resource :league, :except => [:destroy]
  load_and_authorize_resource :except => [:new, :create]

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

  def edit
  end

  def edit_score
  end

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @league, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_score
    scores = (params[:game] || {}).select { |key| ["home_team_score", "visiting_team_score"].include?(key) }
    respond_to do |format|
      if @game.update_attributes(scores)
        format.html { redirect_to @league, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit_score" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @game.update_attributes(:status => :canceled)
        format.html { redirect_to :back, notice: 'Game was successfully canceled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Unable to cancel game.' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
