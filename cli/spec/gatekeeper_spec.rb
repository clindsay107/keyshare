require 'minitest/autorun'
require_relative '../gatekeeper.rb'

# Create a new (random) test vault that we can safely tear down after testing
ENV['VAULT_BUCKET_NAME'] = "keyshare-test-vault-#{Random.rand(100000)}"
puts "Created new test vault: #{ENV['VAULT_BUCKET_NAME']}\n\n"

describe "Gatekeeper" do

  it "should throw an error when a command is called without an existing vault" do
    output = capture_io { Gatekeeper.new.add("testkey123", "testcred123") }.join("")
    output.must_match /^ERROR/
  end

  it "should be able to create a new vault" do
    Gatekeeper.new.create_vault
  end

  after do
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    client = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)
    client.delete_bucket({ bucket: ENV['VAULT_BUCKET_NAME']})
    puts "Test bucket #{ENV['VAULT_BUCKET_NAME']} successfully deleted."
  end

end
