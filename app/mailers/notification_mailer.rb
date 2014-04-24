class NotificationMailer < ActionMailer::Base
  helper :users

  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "BigShot.io")

  def new_feed_items(user, items)
    attachments.inline['avatar.png'] = File.read(Rails.root.join("app/assets/images/fallback/avatar_thumbnail.png"))
    attachments.inline['logo.png'] = File.read(Rails.root.join("app/assets/images/bigshot-logo.png"))
    @items = items
    send_localized_mail(user, "notification_mailer.new_feed_items.subject")
  end

  def no_follows(user)
    attachments.inline['logo.png'] = File.read(Rails.root.join("app/assets/images/bigshot-logo.png"))
    send_localized_mail(user, "notification_mailer.no_follows.subject")
  end

  private

  DEFAULT_LANGUAGE = 'fr'

  def send_localized_mail(user, subject_key)
    @user = user
    I18n.with_locale(user.language || DEFAULT_LANGUAGE) do
      subject = I18n.t(subject_key, :name => user.name)
      subject = "[#{Rails.env}] #{subject}" unless Rails.env.production?
      mail to: [user.email], subject: subject
    end
  end
end

