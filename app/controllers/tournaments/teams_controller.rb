class Tournaments::TeamsController < ApplicationController
  load_and_authorize_resource :tournament

  def edit
  end

  def update
    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to @tournament, notice: 'Tournament team list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end
end
