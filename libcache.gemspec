# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libcache/version'

Gem::Specification.new do |spec|
  spec.name          = "libcache"
  spec.version       = Libcache::VERSION
  spec.authors       = ["silk8192"]
  spec.email         = ["silk8192@gmail.com"]

  spec.summary       = "A caching library that provides an in-memory and file based cache"
  spec.description   = "A caching library that provides an in-memory and file based cache with various functionality similar to Guava's Caching system. For information on how to use: https://github.com/silk8192/libcache"
  spec.homepage      = "https://github.com/silk8192/libcache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
