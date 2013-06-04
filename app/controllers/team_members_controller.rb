class TeamMembersController < ApplicationController
  before_filter :load_team

  def index
    @team_members = @team.team_members
  end

  def new
    @team_member = TeamMember.new(:team => @team)
  end

  def create
    @team_member = TeamMember.new(params[:team_member].merge(team: @team))

    respond_to do |format|
      if @team_member.save
        format.html { redirect_to action: "index", notice: 'Team member was successfully added.' }
        format.json { render json: @team_member, status: :created, location: @team_member }
      else
        format.html { render action: "new" }
        format.json { render json: @team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team_member = TeamMember.find(params[:id])
    @team_member.destroy

    respond_to do |format|
      format.html { redirect_to team_members_url }
      format.json { head :no_content }
    end
  end

  private

  def load_team
    @team = Team.find(params[:team_id])
  end
end
