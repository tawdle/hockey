class InvitationMailer < ActionMailer::Base
  DEFAULT_LANGUAGE = 'fr'

  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def send_localized_mail(invitation)
    @invitation = invitation
    I18n.with_locale(@invitation.creator.language || DEFAULT_LANGUAGE) do
      mail to: @invitation.email
    end
  end

  def manage_league(invitation)
    send_localized_mail(invitation)
  end

  def mark_league(invitation)
    send_localized_mail(invitation)
  end

  def manage_team(invitation)
    send_localized_mail(invitation)
  end

  def claim_player(invitation)
    send_localized_mail(invitation)
  end

  def manage_location(invitation)
    send_localized_mail(invitation)
  end

  def manage_tournament(invitation)
    send_localized_mail(invitation)
  end

  def mark_tournament(invitation)
    send_localized_mail(invitation)
  end

end
