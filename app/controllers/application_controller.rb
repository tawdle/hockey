class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  before_filter :set_locale

  def set_locale
    extracted_locale = params[:locale] || extract_locale_from_accept_language_header || :en

    I18n.locale = (I18n::available_locales.include? extracted_locale.to_sym) ?
      extracted_locale : I18n.default_locale
  end

  private

  # Get locale from "Accept-Language" HTTP Header or return nil if such locale is not available
  #   example: Accept-Language: da, en-gb;q=0.8, en;q=0.7
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
  end

  TLD_LOCALES = {
    "com" => :en,
    "jp" => :ja
  }

  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 example.com
  #   127.0.0.1 example.it
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    tld = request.host.split('.').last
    TLD_LOCALES[tld] || tld
  end

  # Get locale code from request subdomain (like http://it.application.local:3000)
  # You have to put something like:
  #   127.0.0.1 gr.example.local
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_subdomain
    request.subdomains.first
  end
end
