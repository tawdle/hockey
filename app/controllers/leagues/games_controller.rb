class Leagues::GamesController < ApplicationController
  load_and_authorize_resource :league, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource :except => [:new, :create]

  def new
    @game = @league.games.build
    authorize! :new, @game
  end

  def create
    @game = @league.games.build(params[:game].merge(:updater => current_user))
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

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game].merge(:updater => current_user))
        format.html { redirect_to @league, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      @game.updater = current_user
      if @game.cancel
        format.html { redirect_to :back, notice: 'Game was successfully canceled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Unable to cancel game.' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
