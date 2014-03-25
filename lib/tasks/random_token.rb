require 'securerandom'

module RandomToken
  def generate
    Digest::SHA1.hexdigest(SecureRandom.random_bytes(32))
  end

  module_function :generate
end
