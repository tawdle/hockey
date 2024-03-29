class Marker::GoalsController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :except => [:new, :create]

  def index
  end

  def new
    @goal = @game.goals.build
    authorize! :new, @goal
  end

  def create
    @goal = @game.goals.build(params[:goal].merge(:creator => current_user))
    authorize! :create, @goal

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @game, notice: 'Goal was successfully created.' }
        format.json { render json: @goal, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to @game, notice: 'Goal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @goal.updater = current_user
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to @game, notice: 'Goal was removed.' }
      format.json { head :no_content }
    end
  end
end
