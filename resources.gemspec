# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resources/version'

Gem::Specification.new do |spec|
  spec.name          = "resources"
  spec.version       = Resources::VERSION
  spec.authors       = ["Josh Leder"]
  spec.email         = ["josh@ha.cr"]
  spec.summary       = %q{Redis-based resource pool.}
  spec.description   = %q{Resource pool with a distributed lock manager, based on the Redis Redlock algorithm.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  
  spec.add_dependency 'redis', '~> 3.2.1'
  spec.add_dependency 'redlock', '~> 0.1.1'
end
