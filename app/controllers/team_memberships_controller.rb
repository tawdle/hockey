class TeamMembershipsController < ApplicationController
  load_and_authorize_resource :team, :only => [:new, :create]
  load_and_authorize_resource :team_membership, :except => [:new, :create]

  def index
    @team_memberships = @team.team_memberships
  end

  def new
    @team_membership = TeamMembership.new(:team => @team)
    authorize! :create, @team_membership
  end

  def create
    @team_membership = TeamMembership.new(params[:team_membership].merge(team: @team, creator: current_user))
    authorize! :create, @team_membership

    respond_to do |format|
      if @team_membership.save
        format.html { redirect_to @team, notice: "#{@team_membership.member.name} was successfully added as a team member." }
        format.json { render json: @team_membership, status: :created, location: @team_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @team_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end


  def update
    respond_to do |format|
      if @team_membership.update_attributes(params[:team_membership])
        format.html { redirect_to @team_membership.team, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team_membership = TeamMembership.find(params[:id])
    @team_membership.destroy

    respond_to do |format|
      format.html { redirect_to @team_membership.team, notice: "#{@team_membership.member.at_name} was successfully removed." }
      format.json { head :no_content }
    end
  end
end
