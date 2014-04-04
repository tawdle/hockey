class SharedLinksController < ApplicationController
  def new
    @shared_link = SharedLink.new(:link_id => params[:link_id], :user_id => current_user.id)
    authorize! :create, @shared_link
  end

  def create
    @shared_link = SharedLink.new(params[:shared_link].merge(
      :user_id => current_user.id
    ))
    authorize! :create, @shared_link

    respond_to do |format|
      if @shared_link.save
        format.html { render action: "success" }
        format.json { render json: @shared_link, status: :created, location: @shared_link }
      else
        format.html { render action: "new" }
        format.json { render json: @shared_link.errors, status: :unprocessable_entity }
      end
    end
  end
end
