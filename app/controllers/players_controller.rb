class PlayersController < ApplicationController
  load_and_authorize_resource :team, :only => [:new, :create]
  load_and_authorize_resource :player, :except => [:new, :create]

  def index
    @players = @team.players
  end

  def show
    @team = @player.team
    @league = @team.league
  end

  def new
    @player = Player.new(:team => @team)
    authorize! :create, @player
    render :layout => false if request.xhr?
  end

  def create
    @player = Player.new(params[:player].merge(team: @team, creator: current_user))
    authorize! :create, @player

    respond_to do |format|
      if @player.save
        format.html { redirect_to @team, notice: t("controllers.playes.create", :name => @player.name) }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end


  def update
    respond_to do |format|
      if @player.update_attributes(params[:player].merge(creator: current_user))
        format.html { redirect_to @player.team, notice: t('controllers.players.update') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to @player.team, notice: t("controllers.players.destroy", :name => @player.name) }
      format.json { head :no_content }
    end
  end
end
