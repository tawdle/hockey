class InvitationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:accept, :update_fake_user]
  load_and_authorize_resource :except => [:new, :create]

  Target_classes = [League, Team]

  def new
    target_class = params[:target_type] && params[:target_type].constantize
    raise "unexpected value '#{target_class}' for parameter target_type" unless Target_classes.include?(target_class)
    target = target_class.find(params[:target_id].to_i)
    @invitation = Invitation.new(:creator => current_user, :predicate => params[:predicate], :target => target)
    authorize! :create, @invitation
  end

  def create
    @invitation = Invitation.new(params[:invitation].merge(:creator => current_user))
    authorize! :create, @invitation

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to @invitation.target, notice: "Your invitation to #{@invitation.email} has been sent." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def accept
    if current_user.nil? && @invitation.for_fake_user?
      render :edit_fake_user
      return
    end

    authenticate_user!

    if @invitation.state == :accepted
      render :already_accepted
    elsif current_user.email != @invitation.email && params[:confirm].nil?
      render :email_mismatch
    else
      @invitation.accept!(current_user)
      render :congratulations
    end
  end

  def decline
    if @invitation.state == :pending
      @invitation.decline!
    end
    redirect_to :root
  end

  def update_fake_user
    if current_user.nil? && @invitation.for_fake_user?

      respond_to do |format|
        if @invitation.user.update_attributes(params[:user])
          sign_in(@invitation.user)
          format.html { redirect_to accept_invitation_path(@invitation), notice: 'User account was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :edit_fake_user }
          format.json { render json: @invitation.user.errors, status: :unprocessable_entity }
        end
      end

    end
  end
end
