class Admin::KiosksController < ApplicationController
  before_filter :load_kiosk, :only => [:show, :destroy]
  def create
    @kiosk = Kiosk.new(params[:kiosk].merge(:cookies => cookies))
    authorize! :create, @kiosk
    if @kiosk.save
      redirect_to admin_kiosk_path, :notice => "Kiosk mode has been enabled"
    else
      render :new
    end
  end

  def new
    @kiosk = Kiosk.new
    authorize! :create, @kiosk
  end

  def show
    authorize! :read, @kiosk
  end

  def destroy
    authorize! :destroy, Kiosk
    @kiosk.destroy if @kiosk
    redirect_to admin_kiosk_path, :notice => "Kiosk mode has been disabled"
  end

  private

  def load_kiosk
    @kiosk = Kiosk.load_from_cookie(cookies)
  end
end
