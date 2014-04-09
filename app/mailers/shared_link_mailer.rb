class SharedLinkMailer < ActionMailer::Base

  helper :users

  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def share(shared_link)
    attachments.inline['logo.png'] = File.read(Rails.root.join("app/assets/images/bigshot-logo.png"))
    attachments.inline['avatar.png'] = File.read(Rails.root.join("app/assets/images/fallback/avatar_thumbnail.png"))
    @shared_link = shared_link
    send_localized_mail
  end

  DEFAULT_LANGUAGE = 'fr'

  def send_localized_mail
    I18n.with_locale(@shared_link.user.language || DEFAULT_LANGUAGE) do
      subject = I18n.t("shared_link_mailer.share.subject", :user => @shared_link.user.name)
      subject = "[#{Rails.env}] #{subject}" unless Rails.env.production?
      mail to: @shared_link.email, subject: subject
    end
  end
end

