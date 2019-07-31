# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "litecoin_rpc"
  spec.version       = "0.0.2"
  spec.authors       = ["Tim Kretschmer"]
  spec.email         = ["tim@krtschmr.de"]
  spec.description   = %q{connects to the LTC RPC}
  spec.summary       = %q{connects to the LTC RPC}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_rubygems_version = '>= 1.3.6'


end
