class InvitationMailer < ActionMailer::Base
  DEFAULT_LANGUAGE = 'fr'

  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def setup(invitation, subject_prefix=nil)
    @invitation = invitation
    I18n.with_locale(invitation.language || DEFAULT_LANGUAGE) do
      opts = case invitation.target
             when Player
               { :creator_name => invitation.creator.name,
                 :target_name => invitation.target.name,
                 :jersey_number => invitation.target.jersey_number,
                 :team_name => invitation.target.team.name }
             else
               {:creator_name => invitation.creator.name,
                :target_name => invitation.target.name}
             end

      scope = "invitation_mailer.#{invitation.predicate}_#{invitation.target.class.name.downcase}"
      subject = I18n.t(:subject, :scope => scope)
      subject = "#{I18n.t(subject_prefix, :scope => "invitation_mailer")}: #{subject}" if subject_prefix
      @message = I18n.t(:message, opts.merge(:scope => scope))
      mail to: @invitation.email, subject: subject
    end
  end

  def invite(invitation)
    setup(invitation)
  end

  def remind(invitation)
    setup(invitation, :reminder)
  end
end
