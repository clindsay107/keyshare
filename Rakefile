require 'bundler/gem_tasks'
require 'rake/testtask'
# require "envyable"

# Envyable.load('./config/env.yml', 'test')

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/*_test.rb']
end

task :test_gatekeeper do
  ruby "-Ilib:test cli/spec/gatekeeper_spec.rb"
end

task :test_all do
  Rake::Task[:test].invoke
  Rake::Task[:test_gatekeeper].invoke
end

namespace :keyshare do
  desc "Create a keyshare.yml file (or copy from an existing source)"
  task :install, [:destination, :source] do |_, args|
    require 'keyshare/cli/install'
    Keyshare::Install.start([:destination, :source])
  end
end

task :default => :test
