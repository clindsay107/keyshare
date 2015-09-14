require "bundler/gem_tasks"
require "rake/testtask"
require "envyable"

Envyable.load('./config/env.yml', 'test')

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/*_test.rb']
end

task :test_gatekeeper do
  ruby "-Ilib:test cli/spec/gatekeeper_spec.rb"
end

task :default => :test
