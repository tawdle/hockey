class Tournaments::OfficialsController < ApplicationController
  load_and_authorize_resource :tournament
  load_and_authorize_resource :except => [:new, :create]

  def index
  end

  def show
  end

  def new
    @official = @tournament.officials.build
  end

  def create
    @official = @tournament.officials.build(params[:official])

    respond_to do |wants|
      if @official.save
        flash[:notice] = t("controllers.tournaments.officials.create")
        wants.html { redirect_to(tournament_officials_path(@tournament)) }
        wants.xml  { render :xml => @official, :status => :created, :location => @tournament }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @official.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |wants|
      if @official.update_attributes(params[:official])
        flash[:notice] = t("controllers.tournaments.officials.update")
        wants.html { redirect_to(tournament_officials_path(@tournament)) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @official.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @official.destroy

    respond_to do |wants|
      flash[:notice] = t("controllers.tournaments.officials.destroy")
      wants.html { redirect_to(tournament_officials_path(@tournament)) }
      wants.xml  { head :ok }
    end
  end
end
