require 'spec_helper'
require 'keyshare/cli/install'

describe Keyshare do

  def self.setup_env
    if @setup.nil?
      @test_bucket = "keyshare-test-vault-#{Random.rand(100000)}"
      puts "Created new test vault: #{@@test_bucket}\n\n"
      FileUtils::mkdir_p('./tmp/keyshare')
    end
    @setup = true
  end

  describe "rake keyshare:install" do

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
  FileUtils::rm_rf('./tmp/keyshare')
}
