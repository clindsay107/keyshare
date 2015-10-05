require 'bundler/gem_tasks'
require 'rake/testtask'
require 'keyshare/cli/install'
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

task :install do
  Keyshare::ClI.start
end

task :default => :test
