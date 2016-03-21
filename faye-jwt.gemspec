# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faye-jwt/version'

Gem::Specification.new do |spec|
  spec.name          = "faye-jwt"
  spec.version       = FayeJwt::VERSION
  spec.authors       = ["Chen, Yi-Cyuan"]
  spec.email         = ["emn178@gmail.com"]

  spec.summary       = %q{A gem that provides authentication by JWT(json web token) with faye.}
  spec.description   = %q{A gem that provides authentication by JWT(json web token) with faye.}
  spec.homepage      = "https://github.com/emn178/faye-jwt"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
