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
    send_localized_mail(user, items)
  end

  private

  DEFAULT_LANGUAGE = 'fr'

  def send_localized_mail(user, items)
    @user = user
    @items = items
    I18n.with_locale(user.language || DEFAULT_LANGUAGE) do
      mail to: [user.email]
    end
  end
end

