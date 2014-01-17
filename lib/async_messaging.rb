module AsyncMessaging

  FAYE_CONFIG = HashWithIndifferentAccess.new(YAML::load(File.read(Rails.root.join("config/faye.yml"))))[Rails.env]

  def post_form(url, params)
    req = Net::HTTP::Post.new(url.request_uri)
    req.form_data = params
    http = Net::HTTP.new(url.hostname, url.port)
    http.use_ssl = url.scheme == 'https'
    http.start {|http|
      http.request(req)
    }
  end

  def broadcast(channel, msg=nil, &block)
    unless FAYE_CONFIG[:disabled]
      #puts "AsyncMessaging: #{msg || capture(&block)}"
      message = {:channel => channel, :data => msg || capture(&block), :ext => {:password => ENV["FAYE_PASSWORD"]}}
      uri = URI.parse(FAYE_CONFIG[:uri])
      post_form(uri, :message => message.to_json)
      #Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end
end

