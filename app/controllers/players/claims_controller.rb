class Players::ClaimsController < ApplicationController
  load_and_authorize_resource :player
  before_filter :set_kiosk
  before_filter :build_player_claim, :except => [:show, :approve, :deny]
  before_filter :load_player_claim, :only => [:show, :approve, :deny]

  def new
    if @kiosk
      authorize! :claim, @player
    else
      authorize! :create, @player_claim
    end
  end

  def create
    if @kiosk
      authorize! :claim, @player
      password_match = @kiosk && params[:claim] && Kiosk.password_matches(cookies, params[:claim][:kiosk_password])
      respond_to do |format|
        if @player.update_attributes(user_id: current_user.id, kiosk_password_matches: password_match)
          format.html { redirect_to @player, notice: 'You have successfully claimed this player.' }
          format.json { render json: @player, status: :created, location: @player }
        else
          format.html { render action: "new" }
          format.json { render json: @player.errors, status: :unprocessable_entity }
        end
      end
    else
      authorize! :create, @player_claim

      respond_to do |format|
        if @player_claim.save
          format.html { redirect_to @player, notice: "Your claim has been created. We'll email you when your manager responds." }
          format.json { render json: @player_claim, status: created, location: @player }
        else
          format.html { render action: "new" }
          format.json { render json: @player_claim.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def show
    authorize! :read, @player_claim
    @creator = @player_claim.creator
    @team = @player.team
  end

  def approve
    authorize! :approve, @player_claim

    respond_to do |format|
      if @player_claim && @player_claim.approve!(current_user)
        format.html { redirect_to @player_claim.player.team, notice: "You have successfully approved this claim." }
        format.json { render json: @player_claim, status: :created, location: @player }
      else
        format.html { redirect_to @player, notice: "Something went wrong" }
        format.json { render json: @player_claim.errrors, status: :unprocessable_entitty }
      end
    end
  end

  def deny
    authorize! :deny, @player_claim

    respond_to do |format|
      if @player_claim && @player_claim.deny!(current_user)
        format.html { redirect_to @player_claim.player.team, notice: "You have successfully denied this claim." }
        format.json { render json: @player_claim, status: :deleted, location: @player }
      else
        format.html { redirect_to @player, notice: "Something went wrong" }
        format.json { render json: @player_claim.errrors, status: :unprocessable_entitty }
      end
    end
  end

  private

  def set_kiosk
    @kiosk = Kiosk.load_from_cookie(cookies).valid?
  end

  def build_player_claim
    unless @kiosk
      @player_claim = @player.claims.build(:creator => current_user)
    end
  end

  def load_player_claim
    @player_claim = @player.claims.find(params[:id])
  end
end

