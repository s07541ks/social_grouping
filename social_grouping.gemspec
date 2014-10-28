# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_grouping/version'

Gem::Specification.new do |spec|
  spec.name          = "social_grouping"
  spec.version       = SocialGrouping::VERSION
  spec.authors       = ["k-sekido"]
  spec.email         = ["kosuke.sekido@gmail.com"]
  spec.summary       = %q{grouping social account}
  spec.description   = %q{grouping social account}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport"
  spec.add_dependency "twitter", "~>5.9"
  spec.add_dependency "moji", "~>1.6"
  spec.add_dependency "nokogiri", "~>1.6"

end
