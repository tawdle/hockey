class Players::ClaimsController < ApplicationController
  load_and_authorize_resource :player
  before_filter :set_kiosk

  def new
    authorize! :claim, @player
  end

  def create
    authorize! :claim, @player
    password_match = params[:claim] && Kiosk.password_matches(cookies, params[:claim][:kiosk_password])
    respond_to do |format|
      if @player.update_attributes(user_id: current_user.id, kiosk_password_matches: password_match)
        format.html { redirect_to @player, notice: 'You have successfully claimed this player.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_kiosk
    @kiosk = Kiosk.load_from_cookie(cookies).valid?
  end
end
