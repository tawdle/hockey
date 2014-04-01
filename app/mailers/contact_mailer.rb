class ContactMailer < ActionMailer::Base

  def self.format_address(email, display_name)
    address = Mail::Address.new(email)
    address.display_name = display_name
    address.format
  end

  default from: format_address("mailer@bigshot.io", "Contact form at BigShot.io"), to: format_address("info@bigshot.io", "BigShot.io")

  def incoming(contact)
    @contact = contact
    mail subject: "Incoming website contact"
  end
end

