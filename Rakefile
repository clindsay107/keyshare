require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/keyshare_rake_spec.rb', 'spec/loader_spec.rb']
end

Rake::TestTask.new(:external) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/keyshare_spec.rb']
end

task :all do
  Rake::Task[:test].invoke
  Rake::Task[:external].invoke
end

task :default => :test
