class Leagues::OfficialsController < ApplicationController
  load_and_authorize_resource :league
  load_and_authorize_resource :except => [:new, :create]

  def show
  end

  def new
    @official = Official.new
  end

  def create
    @official = @league.officials.build(params[:official])

    respond_to do |wants|
      if @official.save
        flash[:notice] = t("controllers.leagues.officials.create.success")
        wants.html { redirect_to(@league) }
        wants.xml  { render :xml => @official, :status => :created, :location => @league }
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
        flash[:notice] = t("controllers.leagues.officials.update.success")
        wants.html { redirect_to(@league) }
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
      flash[:notice] = t("controllers.leagues.officials.destroy.success")
      wants.html { redirect_to(@league) }
      wants.xml  { head :ok }
    end
  end
end
