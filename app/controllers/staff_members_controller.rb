class StaffMembersController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource :except => [:new, :create]

  def index
  end

  def new
    @staff_member = @team.staff_members.build
    authorize! :new, @staff_member
  end

  def edit
  end

  def create
    @staff_member = @team.staff_members.build(params[:staff_member])
    authorize! :create, @staff_member

    respond_to do |format|
      if @staff_member.save
        format.html { redirect_to team_staff_members_path(@team), notice: 'Staff member was successfully created.' }
        format.json { render json: @staff_member, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @staff_member.update_attributes(params[:staff_member])
        format.html { redirect_to team_staff_members_path(@team), notice: 'Staff member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end
  end
end
