# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crazy_train/version'

Gem::Specification.new do |spec|
  spec.name          = "crazy_train"
  spec.version       = CrazyTrain::VERSION
  spec.authors       = ["Joaquín Moreira"]
  spec.email         = ["jmoreiras@gmail.com"]
  spec.summary       = %q{Yet another ruby micro framework}
  spec.description   = %q{Crazy train is an 'off the rails' ruby micro web framework with simplicity and zero configuration as its more important features! }
  spec.homepage      = "https://www.github.com/joaquinrulin/crazy_train"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.add_development_dependency "byebug", "~> 8.2"
end
