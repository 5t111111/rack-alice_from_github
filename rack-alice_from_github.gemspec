# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/alice_from_github/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-alice_from_github"
  spec.version       = Rack::AliceFromGithub::VERSION
  spec.authors       = ["Hirofumi Wakasugi"]
  spec.email         = ["baenej@gmail.com"]

  spec.summary       = %q{Stubbing logging-in via GitHub OAuth for Sorcery external}
  spec.description   = %q{Stubbing logging-in via GitHub OAuth for Sorcery external}
  spec.homepage      = "https://github.com/5t111111/rack-alice_from_github"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
