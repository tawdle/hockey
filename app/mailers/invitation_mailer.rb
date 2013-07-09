class InvitationMailer < ActionMailer::Base
  default from: "mailer@mygameshot.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.manage_league.subject
  #
  def manage_league(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "[MyGameShot] Invitation to Manage League"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations.manage_team.subject
  #
  def manage_team(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "[MyGameShot] Invitation to Manage Team"
  end

  def join_team(invitation)
    @invitation = invitation

    mail to: @invitation.email, subject: "[MyGameShot] Invitation to Join Team"
  end
end
