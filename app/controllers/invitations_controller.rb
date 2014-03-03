class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:new, :create]

  def new
    target_class = params[:target_type] && params[:target_type].constantize
    raise "unexpected value '#{target_class}' for parameter target_type" unless Invitation::Target_classes.include?(target_class)
    target = target_class.find(params[:target_id].to_i)
    @invitation = Invitation.new(:creator => current_user, :predicate => params[:predicate], :target => target)
    authorize! :create, @invitation
  end

  def create
    @invitation = Invitation.new(params[:invitation].merge(:creator => current_user, :language => I18n.locale))
    authorize! :create, @invitation

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to params[:back_to] || @invitation.target, notice: t("controllers.invitations.create.success", :name => @invitation.try(:user).try(:at_name) || @invitation.email) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def accept
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
end
