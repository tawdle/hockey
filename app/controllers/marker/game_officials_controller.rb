class Marker::GameOfficialsController < ApplicationController
  load_and_authorize_resource :game
  before_filter :load_game_officials

  def edit
    authorize! :edit, GameOfficial.new(:game => @game)
  end

  def update
    authorize! :edit, GameOfficial.new(:game => @game)

    respond_to do |format|
      begin
        if @game.update_attributes(params[:game])
          format.html { redirect_to marker_game_path(@game), notice: t("controllers.marker.game_officials.update.success") }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordInvalid => e
        @game.errors.add(:base, t("controllers.marker.game_officials.update.failure") )
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def load_game_officials
    @game_officials = @game.possible_officials.map {|o| [o.name, o.id] }
  end
end
