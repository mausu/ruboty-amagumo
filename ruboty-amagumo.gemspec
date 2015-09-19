# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/amagumo/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-amagumo"
  spec.version       = Ruboty::YOLP::VERSION
  spec.authors       = ["mausu"]
  spec.email         = ["mausukun_1217@hotmail.co.jp"]

  spec.summary       = "A ruboty handler to get the Amagumo map."
  spec.homepage      = "https://github.com/mausu/ruboty-amagumo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

	spec.add_dependency "ruboty"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
