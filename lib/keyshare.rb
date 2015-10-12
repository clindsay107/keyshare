require 'yaml'
require 'openssl'
require 'keyshare/loader'
require 'keyshare/railtie' if defined?(Rails)

module Keyshare

  VERSION = '0.1.0'
  BUCKET_NAME = 'keyshare-vault'

  # Load a YAML file into ENV
  def self.load(path, env = 'development')
    raise "You must specify a path to your secrets.yml file" if path.empty?
    Loader.new(path).load(env)
  end

  # Retrieve and decrypt the latest `secrets.yml` file from S3
  def self.get
    client = build_client
    response = client.get_object(bucket: BUCKET_NAME, key: 'secrets.yml').body.read
  end

  # Encrypt and upload `secrets.yml` to S3
  def self.upload
    loader  = Loader.new(path, {}).load('keyshare')
    payload = File.open(path)
    client  = build_client(loader.loadable)

    if object_exists?('keyshare.yml', client.client)
      backup('keyshare.yml', client.client)
    end

    client.put_object(bucket: BUCKET_NAME, key: 'secrets.yml', body: payload)

    loader.unload
  end

  private

  def build_client(loadable = ENV)
    credentials = Aws::Credentials.new(loadable['AWS_ACCESS_KEY_ID'], loadable['AWS_SECRET_ACCESS_KEY'])
    master_key = OpenSSL::Digest::SHA256.digest(loadable['KEYSHARE_MASTER_KEY'])
    Aws::S3::Encryption::Client.new(credentials: credentials, encryption_key: master_key)
  end

  # Check (but do not retrieve) an object on S3
  def object_exists?(key, client)
    client.head_object({
      bucket: BUCKET_NAME,
      key: key
    }).successful?
  end

  # Rotate old secrets.yml
  def backup(key, client)
    new_key_name = "#{key}-#{Time.now.to_i}"

    client.copy_object({
      bucket: BUCKET_NAME,
      copy_source: key,
      key: new_key_name
    })
  end

end
