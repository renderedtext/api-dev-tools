# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raml_visualizer/version'

Gem::Specification.new do |spec|
  spec.name          = "raml_visualizer"
  spec.version       = RamlVisualizer::VERSION
  spec.authors       = ["Jovan Ivanović"]
  spec.email         = ["jivanovic@renderedtext.com"]

  spec.summary       = %q{Generates HTML visualizations of API specifications.}
  spec.description   = %q{Generates HTML visualizations of API specifications.}

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redcarpet"
  spec.add_runtime_dependency "raml_parser"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
