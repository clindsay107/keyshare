require 'thor'
require 'aws-sdk'
require 'envyable'
require 'openssl'
require_relative '../lib/keyshare/dse.rb'
Envyable.load('../config/env.yml', 'production')

class Gatekeeper < Thor

  desc "add KEY CREDENTIAL", "Encrypt and a credential under a specified key to the vault"
  option :overwrite, :type => :boolean
  def add(key, credential)
    if key_exists?(key)
      unless options[:overwrite]
        puts "WARNING: Value already exists in vault for key '#{key}'. To overwrite"\
        " the value with a new one, call this method again with the '--overwrite' flag enabled."
        return
      end
    end
    response = crypto_client.put_object(bucket: ENV['VAULT_BUCKET_NAME'], key: key, body: credential)
    if response.successful?
      puts "INFO: Successfully encrypted and added credential value under '#{key}' to #{ENV['VAULT_BUCKET_NAME']}."
    else
      puts response.error
    end
  end

  desc "get KEY", "Retrieve a credential under a specified key from the vault"
  option :decrypt, :type => :boolean
  def get(key)
    if options[:decrypt]
      response = crypto_client.get_object(bucket: ENV['VAULT_BUCKET_NAME'], key: key).body.read
      puts "INFO: Retrieved and decrypted value:\n\n\t#{response}\n\n"
    else
      response = client.get_object(bucket: ENV['VAULT_BUCKET_NAME'], key: key).body.read
      puts "INFO: Retrieved encrypted value:\n\n\t#{response}\n\nHowever, no decrypt flag was specified."\
      " You can call this method again with the '--decrypt' flag to view the decrypted value."
    end
  end

  desc "create_vault", "Create a '#{ENV['VAULT_BUCKET_NAME']}' bucket on S3 with default configuration which acts as your keyring"
  def create_vault
    resp = client.create_bucket({
        bucket: ENV['VAULT_BUCKET_NAME'],
        create_bucket_configuration: { location_constraint: ENV['AWS_REGION'] }
      })

      puts "INFO: Successfully created S3 bucket '#{ENV['VAULT_BUCKET_NAME']}'! You can"\
      " now add a key-value credential pair using the #add command."
  end

  private

  # Helper method to check if a key exists
  def key_exists?(bucket_name = ENV['VAULT_BUCKET_NAME'], key)
    begin
      return client.head_object({ bucket: ENV['VAULT_BUCKET_NAME'], key: key }).successful?
    rescue Aws::S3::Errors::NotFound
      return false
    end
  end

  # Build a new AWS S3 client using supplied credentials in env.yml
  def crypto_client
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    master_key = OpenSSL::Digest::SHA256.digest(ENV['KEYSHARE_MASTER_KEY'])
    Aws::S3::Encryption::Client.new(region: ENV['AWS_REGION'], credentials: credentials, encryption_key: master_key)
  end

  def client
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)
  end

end

Gatekeeper.start(ARGV)
