require 'yaml'
require 'keyshare/version'
require 'keyshare/loader'
require 'keyshare/railtie' if defined?(Rails)

module Keyshare

  # Load a `secrets.yml` file into ENV
  def self.load(path, env = 'development')
    Loader.new(path).load(env)
  end

  # Retrieve and decrypt the latest `secrets.yml` file from S3
  def self.refresh
    # response = client.get_object(bucket: bucket, key: key).body.read
  end

  # Encrypt and upload `secrets.yml` to S3
  def self.upload(path = '')
    raise "You must specify a path to your keyshare.yml file" if path.empty?

    loader = Loader.new(path).load('keyshare')

    loader.unload
  end

  private

  def client(credentials_path)
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    master_key = OpenSSL::Digest::SHA256.digest(ENV['KEYSHARE_MASTER_KEY'])
    Aws::S3::Encryption::Client.new(region: ENV['AWS_REGION'], credentials: credentials, encryption_key: master_key)
  end

end
