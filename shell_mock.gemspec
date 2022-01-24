# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shell_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "shell_mock"
  spec.version       = ShellMock::VERSION
  spec.authors       = ["Chris Hoffman"]
  spec.email         = ["yarmiganosca@gmail.com"]

  spec.summary       = %q{WebMock for shell commands}
  spec.description   = spec.summary
  spec.homepage      = "http://www.github.com/yarmiganosca/shell_mock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency "structured_changelog", "~> 0.8"
  spec.add_development_dependency "asciidoctor"
end
