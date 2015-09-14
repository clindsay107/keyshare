require 'thor'
require 'aws-sdk'
require 'envyable'
Envyable.load('../config/env.yml', 'production')

class Gatekeeper < Thor

  desc "add KEY CREDENTIAL", "Add a credential under a specified key to the vault"
  option :overwrite, :type => :boolean
  def add(key, credential)
    begin
      if key_exists?(key)
        unless options[:overwrite]
          puts "WARNING: Value already exists in vault for key '#{key}'. To overwrite"\
          " the value with a new one, call this method again with the '--overwrite' flag enabled."
          return
        end
      end
      response = build_client.put_object(bucket: ENV['VAULT_BUCKET_NAME'], key: key, body: credential)
      puts "INFO: Successfully added '#{key}' to #{ENV['VAULT_BUCKET_NAME']}."
    rescue Aws::S3::Errors::NoSuchBucket
      puts "ERROR: S3 bucket '#{ENV['VAULT_BUCKET_NAME']}' does not exist on this account/region!"\
      " Either you have misconfigured your AWS settings, or you have not created a"\
      " root-level '#{ENV['VAULT_BUCKET_NAME']}' bucket in S3. You can do so now with the #create_vault command."
    end
  end

  desc "get KEY BUCKET_NAME", "Retrieve a credential under a specified key from the vault"
  option :decrypt, :type => :string
  def get(key)
    begin
      response = build_client.get_object(bucket: ENV['VAULT_BUCKET_NAME'], key: key).body.read
      if options[:decrypt]
        puts "Retrieved and decrypted value:\n\n\t#{response}\n\n"
      else
        puts "Retrieved (encrypted) value:\n\n\t#{response}\n\nHowever, no decrypt flag was specified."\
        " You can call this method again with the '--decrypt \"YOUR KEY\"' to view the decrypted value."
      end
    rescue Aws::S3::Errors::NoSuchKey
      puts "ERROR: Able to connect to S3, but specified key '#{key}' does not exist in S3 bucket '#{ENV['VAULT_BUCKET_NAME']}'."\
      " You can add one using the #add method."
    rescue Aws::S3::Errors::NotFound
      puts "ERROR: S3 bucket '#{ENV['VAULT_BUCKET_NAME']}' does not exist on this account/region!"\
      " Either you have misconfigured your AWS settings, or you have not created a"\
      " root-level '#{ENV['VAULT_BUCKET_NAME']}' bucket in S3. You can do so now with the #create_vault command."
    end
  end

  desc "create_vault", "Create a '#{ENV['VAULT_BUCKET_NAME']}' bucket on S3 with default configuration which acts as your keyring"
  def create_vault
    begin
      resp = build_client.create_bucket({
          bucket: ENV['VAULT_BUCKET_NAME'],
          create_bucket_configuration: { location_constraint: ENV['AWS_REGION'] }
        })

        puts "INFO: Successfully created S3 bucket '#{ENV['VAULT_BUCKET_NAME']}'! You can"\
        " now add a key-value credential pair using the #add command."
    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
      puts "WARNING: Bucket '#{ENV['VAULT_BUCKET_NAME']}' already exists for this account in"\
      " the specified region (#{ENV['AWS_REGION']}). Nothing has been changed or created."\
      " You can use the #add command to place a key-value pair into the vault, or use"\
      " #get to retrieve a value by its key."
    end
  end

  private

  # Helper method to check if a key exists
  def key_exists?(bucket_name = ENV['VAULT_BUCKET_NAME'], key)
    begin
      return build_client.head_object({ bucket: ENV['VAULT_BUCKET_NAME'], key: key }).successful?
    rescue Aws::S3::Errors::NotFound
      return false
    end
  end

  # Build a new AWS S3 client using supplied credentials in env.yml
  def build_client
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)
  end

end

Gatekeeper.start(ARGV)
