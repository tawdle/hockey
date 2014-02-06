class PlayerClaimMailer < ActionMailer::Base
  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def created(player_claim)
    assign_attrs(player_claim)
    mail to: @team.managers.map(&:email)
  end

  def approved(player_claim)
    assign_attrs(player_claim)
    mail to: [@creator.email]
  end

  def denied(player_claim)
    assign_attrs(player_claim)
    mail to: [@creator.email]
  end

  private
  
  def assign_attrs(player_claim)
    @player_claim = player_claim
    @player = player_claim.player
    @creator = player_claim.creator
    @manager = player_claim.manager
    @team = @player.team
  end
end
