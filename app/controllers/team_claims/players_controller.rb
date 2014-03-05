class TeamClaims::PlayersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :team_claim
  load_resource
  before_filter :authorize_claim

  before_filter :load_team

  def edit
  end

  def update
    @player.user = current_user
    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: t("controllers.team_claims.players.update.success") }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_team_claim_player_path(@team_claim, @player), notice: t("controllers.team_claims.players.update.failure") }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize_claim
    authorize! :claim, @player
  end

  def load_team
    @team = @team_claim.team
  end
end
