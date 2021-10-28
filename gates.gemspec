# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gates/version'

Gem::Specification.new do |spec|
  spec.name          = 'gates'
  spec.version       = Gates::VERSION
  spec.authors       = ['Phillip Baker, Yaacob Naftali']
  spec.email         = ['phillbaker@retrodict.com, yaacob.neftali@enviaya.com.mx']
  spec.summary       = %q(Permanent backwards compatibility for changing APIs.)
  spec.homepage      = 'https://github.com/Muztafak/enviaya_versioning.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
