require 'spec_helper'

describe Keyshare do

  def self.setup_env
    if @setup.nil?
      ENV['VAULT_BUCKET_NAME'] = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{ENV['VAULT_BUCKET_NAME']}\n\n"
      FileUtils::mkdir_p('./tmp/keyshare')
    end
    @setup = true
  end

  it "should be able to load a YAML file" do
      Keyshare.load('spec/resources/test.yml', 'production')
      ENV['dog'].must_match('buddy')
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
