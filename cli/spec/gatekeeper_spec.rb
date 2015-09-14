require 'minitest/autorun'
require_relative '../gatekeeper.rb'

describe "Gatekeeper" do

  # Hacky way to run ONCE before spec suite
  def self.setup_env
    if @setup.nil?
      puts "Setting up test environment..."
      ENV['VAULT_BUCKET_NAME'] = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{ENV['VAULT_BUCKET_NAME']}\n\n"
    end
    @setup = true
  end

  # Create a new (random) test vault that we can safely tear down after testing
  before do
    self.class.setup_env
  end

  it "should raise an error when a command is called without an existing vault" do
    assert_raises(Aws::S3::Errors::NoSuchBucket) { Gatekeeper.new.add("testkey123", "testcred123")}
  end

  it "should be able to create a new vault" do
    Gatekeeper.new.create_vault
  end

end

Minitest.after_run {
  puts "\n\nCleaning up test environment..."
  credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  client = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)
  client.delete_bucket({ bucket: ENV['VAULT_BUCKET_NAME']})
  puts "Test bucket #{ENV['VAULT_BUCKET_NAME']} successfully deleted."
}
