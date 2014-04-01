class ContactsController < ApplicationController
  skip_authorization_check

  def new
    @contact = Contact.new
    if current_user
      @contact.name = current_user.name
      @contact.email = current_user.email
    end
  end

  def create
    @contact = Contact.new(params[:contact].merge(
      ip: request.remote_ip,
      referer: request.referer,
      useragent: request.env['HTTP_USER_AGENT']
    ))

    respond_to do |format|
      if @contact.save
        format.html { render action: "success" }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
end
