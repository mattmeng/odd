# coding: utf-8
lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift( lib ) unless $LOAD_PATH.include?( lib )
require 'odd/constants'

Gem::Specification.new do |spec|
  spec.name          = "odd"
  spec.version       = Odd::VERSION
  spec.authors       = ["Matt Meng"]
  spec.email         = ["mengmatt@gmail.com"]

  spec.summary       = %q{An odd little embedded database for Ruby.}
  spec.description   = %q{An odd little embedded database for Ruby.}
  spec.homepage      = "https://www.github.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?( :metadata )
    spec.metadata['allowed_push_host'] = "localhost"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir["{exe,lib}/**/*"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep( %r{^exe/} ) {|f| File.basename( f )}
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/odd/extconf.rb"]

  spec.add_dependency "json", '~> 1.8'
  spec.add_dependency "nesty", '~> 1.0'
  spec.add_dependency "bindata", '~> 2.1'
  spec.add_dependency "activesupport", '~> 4.2'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
