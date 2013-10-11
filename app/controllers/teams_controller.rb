class TeamsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :league, :only => [:new, :create]
  load_and_authorize_resource

  # GET /teams
  # GET /teams.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    @team = Team.new
    @team.build_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /leagues/1/teams
  # POST /leagues/1/teams.json
  def create
    params[:team] ||= {}
    params[:team][:user_attributes] ||= {}
    username = params[:team][:user_attributes][:name]
    params[:team][:user_attributes] =  {
      :name => username,
      :email => "#{username}_fake@powerplay.io",
      :password => Digest::SHA1.hexdigest(Time.now.to_s) }

    @team = Team.new(params[:team].merge(:manager => current_user, :league => @league))

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
