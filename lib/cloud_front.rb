# A simple function to return a signed, expiring url for Amazon Cloudfront.
# As it's relatively difficult to figure out exactly what is required, I've posted my working code here.

# This will require openssl, digest/sha1, base64 and maybe other libraries.
# In my rails app, all of these are already loaded so I'm not sure of the exact dependencies.

module CloudFront
  KeyPairId = "APKAJNTWLTE6X667CYEA"

  def get_signed_expiring_url(path, expires_in)

    # AWS works on UTC, so make sure you are not using local time
    expires = (Time.now.getutc + expires_in).to_i.to_s

    private_key = OpenSSL::PKey::RSA.new(File.read("app/data/pk-#{KeyPairId}.pem"))

    # path should be your S3 path without a leading slash and without a file extension.
    # e.g. files/private/52
    policy = %Q[{"Statement":[{"Resource":"#{path}","Condition":{"DateLessThan":{"AWS:EpochTime":#{expires}}}}]}]
    signature = Base64.strict_encode64(private_key.sign(OpenSSL::Digest::SHA1.new, policy))

    # I'm not sure exactly why this is required, but it's in Amazon's perl script and seems necessary
    # Different base64 implementations maybe?
    signature.tr!("+=/", "-_~")

    "#{path}?Expires=#{expires}&Signature=#{signature}&Key-Pair-Id=#{KeyPairId}"
  end

  module_function :get_signed_expiring_url
end
