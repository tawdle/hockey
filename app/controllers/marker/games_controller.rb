class Marker::GamesController < ApplicationController
  load_and_authorize_resource :league, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource :except => [:new, :create]

  def show
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

  def pause
    respond_to do |format|
      if @game.pause_with_elapsed_time(params[:elapsed_time])
        format.html { redirect_to :back, notice: 'Game clock has been stopped.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  def finish
    respond_to do |format|
      if @game.finish
        format.html { redirect_to :back, notice: 'The game has been ended.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  def activate
    @game.marker = current_user
    respond_to do |format|
      if @game.activate
        format.html { redirect_to :back, notice: 'Game has been activated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
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

  def sync
    respond_to do |format|
      if @game.sync
        format.html { redirect_to :back, notice: 'Game has been synced. Thanks.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: 'Something went wrong.' }
        format.json { render json: ["Something went wrong."], status: :unprocessable_entity }
      end
    end
  end

  AcceptableUpdateClockKeys = ["current_period_duration"]

  def update_clock
    respond_to do |format|
      if @game.update_attributes(params[:game].select {|key, val| AcceptableUpdateClockKeys.include?(key) })
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_mvp
    player_id = params[:game] && params[:game][:mvp_player_id].try(:to_i)
    if player_id && @game.game_players.map(&:player_id).include?(player_id)
      player = Player.find(player_id)
      team = player.team
      if team == @game.home_team
        @game.home_team_mvp = player
      else
        @game.visiting_team_mvp = player
      end
    end

    respond_to do |format|
      if @game.save
        @game.broadcast_changes
        format.html { redirect_to @game, notice: 'Game MVP was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
