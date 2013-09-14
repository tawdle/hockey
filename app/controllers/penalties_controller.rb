class PenaltiesController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :except => [:create]

  def create
    @penalty = Penalty.new(params[:penalty].merge(:game => @game, :period => @game.period, :elapsed_time => @game.elapsed_time))
    authorize! :create, @penalty

    respond_to do |format|
      if @penalty.save
        format.html { redirect_to @game, notice: 'Penalty was successfully created.' }
        format.json { render json: @penalty, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @penalty.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @penalty.update_attributes(params[:penalty])
        format.html { redirect_to @game, notice: 'Penalty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @penalty.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @penalty.destroy

    respond_to do |format|
      format.html { redirect_to @game, notice: 'Penalty was removed.' }
      format.json { head :no_content }
    end
  end
end

