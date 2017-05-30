require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "raml_visualizer"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
  sh "irb -rubygems -I lib -r raml_visualizer.rb"
end
