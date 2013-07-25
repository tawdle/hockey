class GoalsController < ApplicationController
  load_and_authorize_resource :game

  def new
    @goal = Goal.new(:game => @game)
    authorize! :new, @goal
  end

  def create
    @goal = Goal.new(params[:goal].merge(:creator => current_user, :game => @game))
    authorize! :create, @goal

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @game, notice: 'Goal was successfully created.' }
        format.json { render json: @goal, status: :created, location: @goal }
      else
        format.html { render action: "new" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end
end
