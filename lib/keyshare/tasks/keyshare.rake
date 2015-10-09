require 'keyshare'

namespace :keyshare do

  desc "Create a secrets.yml file (or copy from an existing source)"
  task :install, :destination, :source do |t, args|
    require 'keyshare/cli/install'

    command = []
    command << "-d=#{args[:destination]}" if args[:destination]
    command << "-s=#{args[:source]}" if args[:source]

    Keyshare::Install.start(command)
  end

  desc "Retrieve the latest secrets.yml from S3"
  task :get do
    Keyshare.get
    puts "Successfully retrieved secrets.yml"
  end

  desc "Encrypt and upload your current secrets.yml to S3"
  task :upload, :path do
    Keyshare.upload(args[:path])
    puts "Successfully uploaded secrets.yml"
  end

end
