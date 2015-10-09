require 'spec_helper'
require 'keyshare/cli/install'

describe Keyshare do

  def self.setup_env
    if @setup.nil?
      ENV['VAULT_BUCKET_NAME'] = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{ENV['VAULT_BUCKET_NAME']}\n\n"
      FileUtils::mkdir_p('./tmp/keyshare')
    end
    @setup = true
  end

  it "should fail on Keyshare.Install with no args" do
    command = ''
    output = get_output(Keyshare::Install, command)
    output.must_match /^No value provided for required options/
  end

  it "should copy default files to specified destination" do
    command = '-d=./tmp/keyshare/'
    output = get_output(Keyshare::Install, command).strip
    assert(File.exist?('./tmp/keyshare/example.keyshare.yml'))
    assert(File.exist?('./tmp/keyshare/example.secrets.yml'))
  end

  private

  # Helper method to capture the output from an array of command line args
  def get_output(receiver, command)
    command = command.split
    capture_io { receiver.start(command) }.join.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

end

Minitest.after_run {
  puts "\nCleaning up test environment..."

  # credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  # client = Aws::S3::Client.new(region: ENV['AWS_REGION'], credentials: credentials)
  #
  # # Delete all objects in our test bucket
  # client.delete_objects({
  #   bucket: ENV['VAULT_BUCKET_NAME'],
  #   delete: {
  #     objects: [
  #       {
  #         key: TEST_KEY_1
  #       }
  #     ]
  #   }
  # })
  #
  # # Delete the now-empty bucket
  # client.delete_bucket({ bucket: ENV['VAULT_BUCKET_NAME'] })

  FileUtils::rm_rf('./tmp/keyshare')

  puts "Test bucket #{ENV['VAULT_BUCKET_NAME']} successfully deleted.\n\n"
}
