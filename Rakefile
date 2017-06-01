require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "raml_visualizer"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
  sh "irb -rubygems -I lib -r raml_visualizer.rb"
end

namespace :docs do
  desc "It generates the documentation pages"
  task :generate, [:source, :destination, :templates] do |_t, args|
    RamlVisualizer::RootController.new(args[:source], args[:destination], args[:templates]).generate_pages
  end
end
