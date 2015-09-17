require 'openssl'
require 'base64'

module Keyshare
  # Dead Simple Encryption :^)
  module DSE

    DEFAULT_CIPHER = "aes-256-cbc"

    def self.encrypt(data, password, cipher_type = DEFAULT_CIPHER)
      hashed_password = OpenSSL::Digest::SHA256.digest(password)
      encrypted_data = encrypt_data(data.to_s.strip, hashed_password, cipher_type)
      Base64.encode64(encrypted_data)
    end

    def self.decrypt(data, password, cipher_type = DEFAULT_CIPHER)
      decoded_data = Base64.decode64(data.to_s.strip)
      self.decrypt_data(decoded_data, password, cipher_type)
    end

    private

    def self.encrypt_data(data, password, cipher_type)
      cipher = OpenSSL::Cipher.new(cipher_type)
      cipher.encrypt
      cipher.key = password
      cipher.iv = iv = cipher.random_iv

      # final result: 16 byte IV + cipher block + final block
      iv + cipher.update(data) + cipher.final
    end

    def self.decrypt_data(data, password, cipher)
      cipher = OpenSSL::Cipher.new(cipher)
      cipher.decrypt
      cipher.key = OpenSSL::Digest::SHA256.digest(password)
      cipher.iv = data.slice!(0,16)
      cipher.update(data) + cipher.final
    end

  end
end
