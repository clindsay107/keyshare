require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/*_test.rb']
end

# task :test_gatekeeper do
#   ruby "-Ilib:test cli/spec/gatekeeper_spec.rb"
# end
#
# task :test_all do
#   Rake::Task[:test].invoke
#   Rake::Task[:test_gatekeeper].invoke
# end

namespace :keyshare do

  desc "Create a env.yml file (or copy from an existing source)"
  task :install, :destination, :source do |t, args|
    require 'keyshare/cli/install'

    dest    = args[:destination]
    source  = args[:source]

    Keyshare::Install.start(["-d=#{dest}", "-s=#{source}"])
  end

  desc "Retrieve the latest env.yml from S3"
  task :refresh
    require 'keyshare'
    Keyshare.refresh
  end

end

task :default => :test
