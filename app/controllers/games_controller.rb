class GamesController < ApplicationController
  load_and_authorize_resource :league, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource :except => [:new, :create]

  def show
  end

  def new
    @game = Game.new(:home_team => @league.teams.first, :visiting_team => @league.teams.second)
    authorize! :new, @game
  end

  def create
    @game = Game.new(params[:game].merge(:updater => current_user))
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

  def start
    respond_to do |format|
      if @game.start
        format.html { redirect_to :back, notice: 'Game has been started.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  def stop
    respond_to do |format|
      if @game.pause
        format.html { redirect_to :back, notice: 'Game clock has been stopped.' }
        format.json { head :no_content }
      else
        format.html { redirect_ to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  def activate
    respond_to do |format|
      if @game.activate
        format.html { redirect_to :back, notice: 'Game has been activated.' }
        format.json { head :no_content }
      else
        format.html { redirect_ to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  def complete
    respond_to do |format|
      if @game.complete
        format.html { redirect_to :back, notice: 'Game has been completed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end
end
