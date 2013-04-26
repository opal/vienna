# -*- encoding: utf-8 -*-
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'vienna/version'

Gem::Specification.new do |s|
  s.name         = 'vienna'
  s.version      = Vienna::VERSION
  s.author       = 'Adam Beynon'
  s.email        = 'adam@adambeynon.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = '.'
  s.description  = '..'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_dependency 'rake'
  s.add_dependency 'opal', '~> 0.3.36'
  s.add_dependency 'opal-jquery', '~> 0.0.5'

  s.add_development_dependency 'opal-spec', '~> 0.2.10'
end
