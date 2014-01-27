class Marker::GameStaffMembersController < ApplicationController
  load_and_authorize_resource :game
  before_filter :load_home_or_visiting
  before_filter :load_team
  before_filter :load_and_authorize_staff_member, :only => [:new, :create]
  before_filter :authorize_game_staff_member, :only => [:edit, :update]

  def new
  end

  def create
    game_staff_member = @game.game_staff_members.build(:role => @staff_member.role, :staff_member => @staff_member)
    respond_to do |format|
      if game_staff_member.save
        format.html { redirect_to marker_game_path(@game), notice: 'Staff member was successfully created.' }
        format.json { render json: @staff_member, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @game.update_attributes(fix_params[:game])
        format.html { redirect_to marker_game_path(@game), notice: 'Game staff member list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize_game_staff_member
    authorize! :create, GameStaffMember.new(:game => @game)
  end

  def load_and_authorize_staff_member
    @staff_member = @team.staff_members.build(params[:staff_member])
    authorize! :create, @staff_member
  end

  def fix_params
    return params unless params[:game] && params[:game][:game_staff_members_attributes]
    # First, get rid of entries for which we haven't persisted anything and which haven't been selected
    params[:game][:game_staff_members_attributes].delete_if { |k, v| !v[:id] && !v[:selected] }

    # Then, add the "_destroy" directive to anything that remains and is unselected
    params[:game][:game_staff_members_attributes].each do |k, v|
      v[:_destroy] = true unless v[:selected]
      v.delete(:selected)
    end

    # Leave untouched anything that is selected -- they'll be created or updated as appropriate
    params
  end

  def load_home_or_visiting
    @home_or_visiting = params[:team] == "visiting" ? "visiting" : "home"
  end

  def load_team
    @team = @game.send("#{@home_or_visiting}_team")
    @other_team = @game.opposing_team(@team)
  end
end
