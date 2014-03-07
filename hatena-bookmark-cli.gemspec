# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hatena-bookmark-cli/version'

Gem::Specification.new do |spec|
  spec.name          = "hatena-bookmark-cli"
  spec.version       = HatenaBookmarkCLI::VERSION
  spec.authors       = ["Hiroyuki Sano"]
  spec.email         = ["sh19910711@gmail.com"]
  spec.summary       = %q{Hatena Bookmark CLI}
  spec.description   = %q{Hatena Bookmark CLI}
  spec.homepage      = "https://github.com/sh19910711/ruby-hatena-bookmark-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "rack_csrf"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "haml"
  spec.add_dependency "oauth"
  spec.add_dependency "bigdecimal"
  spec.add_dependency "activesupport"
  spec.add_dependency "ratom"
  spec.add_dependency "highline"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
