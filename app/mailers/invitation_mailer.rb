class InvitationMailer < ActionMailer::Base
  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@powerplay.io", "PowerPlay.io")

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.manage_league.subject
  #
  def manage_league(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Manage League"
  end

  def mark_league(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to become Marker for League"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.manage_team.subject
  #
  def manage_team(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Manage Team"
  end

  def join_team(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Join Team"
  end

  def claim_player(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Claim Player"
  end

  def manage_location(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Manage Location"
  end

  def manage_tournament(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "Invitation to Manage Tournament"
  end


end
