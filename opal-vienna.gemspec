# -*- encoding: utf-8 -*-
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'vienna/version'

Gem::Specification.new do |s|
  s.name         = 'opal-vienna'
  s.version      = Vienna::VERSION
  s.author       = 'Adam Beynon'
  s.email        = 'adam@adambeynon.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = 'Client side MVC framework for Opal'
  s.description  = 'Client side MVC framework for Opal'
  s.license      = 'MIT'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'opal', ['>= 0.5.0', '< 1.0.0']
  s.add_dependency 'opal-jquery'
  s.add_dependency 'opal-activesupport'

  s.add_development_dependency 'opal-rspec', '>= 0.2.1'
  s.add_development_dependency 'rake'
end
