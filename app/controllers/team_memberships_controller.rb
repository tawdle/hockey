class TeamMembershipsController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource :team_membership

  def index
    @team_memberships = @team.team_memberships
  end

  def new
    @team_membership = TeamMembership.new(:team => @team)
  end

  def create
    @team_membership = TeamMembership.new(params[:team_membership].merge(team: @team))

    respond_to do |format|
      if @team_membership.save
        format.html { redirect_to action: "index", notice: 'Team member was successfully added.' }
        format.json { render json: @team_membership, status: :created, location: @team_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @team_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team_membership = TeamMembership.find(params[:id])
    @team_membership.destroy

    respond_to do |format|
      format.html { redirect_to team_memberships_url }
      format.json { head :no_content }
    end
  end
end
