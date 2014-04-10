class SystemNamesController < ApplicationController
  skip_authorization_check

  def show
    system_name = SystemName.where("lower(name) = ?", (params[:id] || "").downcase).first
    raise ActiveRecord::RecordNotFound unless system_name
    nameable = system_name.nameable
    if nameable.is_a?(Team) && params[:j]
      nameable = nameable.players.where(:jersey_number => params[:j]).first || nameable
    end
    redirect_to nameable
  end
end
