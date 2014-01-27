class GamesController < ApplicationController
  load_and_authorize_resource :league, :only => [:new, :create, :edit, :update]
  load_and_authorize_resource :except => [:new, :create]

  def show
    respond_to do |format|
      format.html
      format.pdf do
        send_data Gamesheets::HockeyQuebec.new(game: @game).to_pdf,
          filename: "game-#{@game.id}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
end
