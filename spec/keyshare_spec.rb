require 'spec_helper'
require 'aws-sdk'
require 'openssl'

describe Keyshare do

  def self.setup_env
    if @setup.nil?
      @test_bucket = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{@test_bucket}\n\n"
      FileUtils::mkdir_p('./tmp/keyshare')
    end
    @setup = true
  end

  describe "helper instance methods" do

    it "should keep helper methods private" do
      [:build_client, :object_exists?, :backup].each do |method|
        assert(Keyshare.private_method_defined?(method))
      end
    end
  end

  describe "client" do

    # it "should be able to build a client from ENV variables" do
    #   Class.new.extend(Keyshare).send(:build_client)
    # end
  end

  describe "load" do

    it "should be able to load a YAML file" do
      Keyshare.load('spec/resources/test.yml', 'production')
      ENV['dog'].must_match('buddy')
    end
  end

  # describe "get" do
  #   before do
  #     Keyshare.load('spec/resources/secrets.yml')
  #     credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  #     key = OpenSSL::Digest::SHA256.digest('p4ssw0rd')
  #     client = Aws::S3::Encryption::Client.new(region: ENV['AWS_REGION'], credentials: credentials, encryption_key: key)
  #     client.put_object(bucket: @test_bucket, key: 'test-key', body: File.open('spec/resources/test.yml'))
  #   end
  #
  #   it "should be able to retrieve and decrypt fom S3" do
  #     p Keyshare.get('spec/resources/secrets.yml')
  #   end
  # end

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
  # client = Aws::S3::Encryption::Client.new(credentials: credentials, encryption_key: master_key)
  #
  # # Delete all objects in our test bucket
  # client.delete_objects({
  #   bucket: @test_bucket,
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
  # client.delete_bucket({ bucket: @test_bucket })

  FileUtils::rm_rf('./tmp/keyshare')

  puts "Test bucket #{@test_bucket} successfully deleted.\n\n"
}
