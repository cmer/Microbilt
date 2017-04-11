# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microbilt/version'

Gem::Specification.new do |spec|
  spec.name          = "microbilt"
  spec.version       = Microbilt::VERSION
  spec.authors       = ["Carl Mercier"]
  spec.email         = ["foss@carlmercier.com"]

  spec.summary       = %q{Simple library to interface with Microbilt's IBV API}
  spec.description   = %q{Simple library to interface with Microbilt's IBV API}
  spec.homepage      = "http://www.github.com/cmer/microbilt"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.13"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "dotenv"

  if RUBY_PLATFORM =~ /darwin/
    spec.add_development_dependency 'ruby_gntp', "~> 0.3.4"
    spec.add_development_dependency 'terminal-notifier-guard', '~> 1.6.1'
  end
end
