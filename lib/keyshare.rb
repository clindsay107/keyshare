require 'yaml'
require 'keyshare/version'
require 'keyshare/loader'
require 'keyshare/railtie' if defined?(Rails)

module Keyshare

  # Load a `secrets.yml` file into ENV
  def self.load(path, env = 'development')
    Loader.new(path).load(env)
  end

  # Retrieve the latest `keyshare.yml` file from S3
  def self.refresh
    # response = client.get_object(bucket: bucket, key: key).body.read
  end

  private

  def client
    loader = Loader.new(path)
    loader.load('keyshare')

    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    master_key = OpenSSL::Digest::SHA256.digest(ENV['KEYSHARE_MASTER_KEY'])
    Aws::S3::Encryption::Client.new(region: ENV['AWS_REGION'], credentials: credentials, encryption_key: master_key)

    loader.unload
  end

end
