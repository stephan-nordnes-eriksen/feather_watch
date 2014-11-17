# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feather_watch/version'

Gem::Specification.new do |spec|
  spec.name          = "feather_watch"
  spec.version       = FeatherWatch::VERSION
  spec.authors       = ["Stephan Nordnes Eriksen"]
  spec.email         = ["stephanruler@gmail.com"]
  spec.summary       = %q{Barebones, simple, and super-fast file system watcher}
  spec.description   = %q{A barebones file system watcher which uses native file system events for Linux, OSx, and Windows.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rb-fsevent', '~> 0.9'
  spec.add_dependency 'rb-inotify', '~> 0.9'
  spec.add_dependency 'wdm', '~> 0.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
