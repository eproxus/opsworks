# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opsworks/version'

Gem::Specification.new do |spec|
  spec.name          = "opsworks"
  spec.version       = Opsworks::VERSION
  spec.authors       = ["Adam Lindberg"]
  spec.email         = ["hello@alind.io"]
  spec.description   = %q{Amazon OpsWorks CLI}
  spec.summary       = %q{Command line interface for Amazon OpsWorks}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "inifile", "~> 2.0.2"
  spec.add_dependency "aws-sdk", "~> 1.11.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "awesome_print"
end
