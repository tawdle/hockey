class LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @locations = Location.without_deleted
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to location_path(@location), notice: t("controllers.locations.create.success") }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to location_path(@location), notice: t("controllers.locations.update.success") }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
end
