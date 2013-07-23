class LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @locations = Location.all
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
        format.html { redirect_to locations_path, notice: 'Location was successfully created.' }
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
        format.html { redirect_to locations_path, notice: 'Location was successfully updated.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
end