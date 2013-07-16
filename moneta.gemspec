# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "moneta/version"

Gem::Specification.new do |s|
  s.name        = "ugalic_moneta"
  s.version     = Moneta::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Uros Galic"]
  s.email       = ["uros.galic@antiveb.com"]
  s.homepage    = ""
  s.summary     = %q{Mobilte Moneta eTreminal}
  s.description = %q{Provides communication with Moneta Web Service}

  s.rubyforge_project = "ugalic_moneta"
  s.add_development_dependency "rspec"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'savon', "~> 2.0"
end
