module AsyncMessaging

  FAYE_CONFIG = HashWithIndifferentAccess.new(YAML::load(File.read(Rails.root.join("config/faye.yml"))))[Rails.env]

  def broadcast(channel, msg=nil, &block)
    unless FAYE_CONFIG[:disabled]
      #puts "AsyncMessaging: #{msg || capture(&block)}"
      message = {:channel => channel, :data => msg || capture(&block), :ext => {:password => ENV["FAYE_PASSWORD"]}}
      # We don't really need to use https here, and the code to POST over SSL is strangely nasty
      uri = URI.parse(FAYE_CONFIG[:uri].sub(/^https/, "http"))
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end
end

