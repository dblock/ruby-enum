$:.push File.expand_path("../lib", __FILE__)
require 'ruby-enum/version'

Gem::Specification.new do |s|
  s.name = "ruby-enum"
  s.version = Ruby::Enum::VERSION
  s.authors = [ "Daniel Doubrovkine" ]
  s.email = "dblock@dblock.org"
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = `git ls-files`.split("\n")
  s.require_paths = [ "lib" ]
  s.homepage = "http://github.com/dblock/ruby-enum"
  s.licenses = [ "MIT" ]
  s.summary = "Enum-like behavior for Ruby."
end