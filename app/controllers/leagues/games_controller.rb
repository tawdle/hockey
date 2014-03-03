class Leagues::GamesController < ApplicationController
  load_and_authorize_resource :league, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource :except => [:new, :create]

  def new
    @game = @league.games.build
    authorize! :new, @game
  end

  def create
    @game = @league.games.build(params[:game].merge(:updater => current_user))
    authorize! :create, @game

    respond_to do |format|
      if @game.save
        format.html { redirect_to league_path(@league), notice: t("controllers.leagues.games.create.success") }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game].merge(:updater => current_user))
        format.html { redirect_to @league, notice: t("controllers.leagues.games.update.success") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      @game.updater = current_user
      if @game.cancel
        format.html { redirect_to :back, notice: t("controllers.leagues.games.destroy.success") }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: t("controllers.leagues.games.destroy.failure") }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
