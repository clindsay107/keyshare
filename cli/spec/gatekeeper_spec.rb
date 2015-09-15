require 'minitest/autorun'
require_relative '../gatekeeper.rb'

describe "Gatekeeper" do

  TEST_KEY_1= "testkey123"
  TEST_CRED_1 = "testcred456"

  # Hacky way to run ONCE before spec suite
  def self.setup_env
    if @setup.nil?
      ENV['VAULT_BUCKET_NAME'] = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{ENV['VAULT_BUCKET_NAME']}\n\n"
    end
    @setup = true
  end

  # Bad... but whatever...
  def self.test_order
    :alpha
  end

  # Create a new (random) test vault that we can safely tear down after testing
  before do
    self.class.setup_env
  end

  # Creating a vault

  it "should raise an error when a command is called without an existing vault" do
    assert_raises(Aws::S3::Errors::NoSuchBucket) { Gatekeeper.new.add(TEST_KEY_1, TEST_CRED_1) }
  end

  it "should be able to create a new vault" do
    command = ["create_vault"]
    output = get_output(command)
    output.must_match /^INFO: Successfully created S3 bucket '#{ENV['VAULT_BUCKET_NAME']}/
  end

  # Adding keys to a vault

  it "should be able to add a key to an existing vault" do
    command = command = ["add", TEST_KEY_1, TEST_CRED_1]
    output = get_output(command)
    output.must_match /^INFO: Successfully added/
  end

  it "should get an error when attempting to add an existing key" do
    command = ["add", TEST_KEY_1, TEST_CRED_1]
    output = get_output(command)
    output.must_match /^WARNING: Value already exists in vault/
  end

  it "should be able to add an existing key with --overwrite flag" do
    command = ["add", TEST_KEY_1, TEST_CRED_1, "--overwrite"]
    output = get_output(command)
    output.must_match /^INFO: Successfully added/
  end

  # Retrieving a key from the vault

  it "should be able to get an existing key" do
    command = ["get", TEST_KEY_1]
    output = get_output(command)
    output.must_match /^INFO: Retrieved \(encrypted\) value/
  end

  private

  # Helper method to capture the output from an array of command line args
  def get_output(command)
    capture_io { Gatekeeper.start(command) }.join("")
  end

end

Minitest.after_run {
  puts "\nCleaning up test environment..."

  credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  client = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)

  # Delete all objects in our test bucket
  client.delete_objects({
    bucket: ENV['VAULT_BUCKET_NAME'],
    delete: {
      objects: [
        {
          key: TEST_KEY_1
        }
      ]
    }
  })

  # Delete the now-empty bucket
  client.delete_bucket({ bucket: ENV['VAULT_BUCKET_NAME'] })

  puts "Test bucket #{ENV['VAULT_BUCKET_NAME']} successfully deleted.\n\n"
}
