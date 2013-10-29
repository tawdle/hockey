class SystemNamesController < ApplicationController
  skip_authorization_check

  def show
    system_name = SystemName.find_by_name!(params[:id])
    nameable = system_name.nameable
    if nameable.is_a?(Team) && params[:j]
      nameable = nameable.players.where(:jersey_number => params[:j]).first || nameable
    end
    redirect_to nameable
  end
end
