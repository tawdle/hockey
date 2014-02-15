class GamesController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.html
      format.pdf do
        send_data Gamesheets::HockeyQuebec.new(game: @game).to_pdf,
          filename: "game-#{@game.id}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
end
