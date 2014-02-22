class PlayerClaimMailer < ActionMailer::Base
  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def created(player_claim)
    team = player_claim.player.team
    send_localized_mail(player_claim, team.managers.presence || team.league.managers.presence || User.admins)
  end

  def approved(player_claim)
    send_localized_mail(player_claim, [player_claim.creator])
  end

  def denied(player_claim)
    send_localized_mail(player_claim, [player_claim.creator])
  end

  private

  DEFAULT_LANGUAGE = 'fr'

  def send_localized_mail(player_claim, to_users)
    assign_attrs(player_claim)
    I18n.with_locale(to_users.first.language || DEFAULT_LANGUAGE) do
      mail to: to_users.map(&:email)
    end
  end

  def assign_attrs(player_claim)
    @player_claim = player_claim
    @player = player_claim.player
    @creator = player_claim.creator
    @manager = player_claim.manager
    @team = @player.team
  end
end
