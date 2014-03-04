class TeamClaimsController < ApplicationController
  load_and_authorize_resource

  before_filter :load_team, :except => :create

  def show
    @players = current_user ? @team.players.where(:user_id => current_user.id) : []
    if @players.any?
      @already_claimed = true
    else
      @already_claimed = false
      @players = @team.players
    end
  end

  def create
    @team_claim = TeamClaim.where(:team_id => params[:team_claim].try(:[], :team_id)).first || TeamClaim.new(params[:team_claim])

    respond_to do |format|
      if @team_claim.save
        @team = @team_claim.team
        format.html { render :created, notice: t("controllers.team_claims.create.success") }
        format.json { render json: @team_claim, status: :created, location: @team_claim }
      else
        format.html { redirect_to @team_claim.team, notice: t("controller.teams.claims.create.failure") }
        format.json { render json: @team_claim.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_team
    @team = @team_claim.team
  end
end
