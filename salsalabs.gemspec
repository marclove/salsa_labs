lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'salsa_labs/version'

Gem::Specification.new do |s|
  s.name = 'salsalabs'
  s.version = SalsaLabs::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Marc Love']
  s.email = ['marcslove@gmail.com']
  s.homepage = 'https://github.com/marcslove/salsa_labs'
  s.summary = 'Salsa Labs API client library'
  s.licenses = ['MIT']
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency 'activesupport', '>= 2.0.0'
  s.add_dependency 'nokogiri'
  s.add_dependency 'faraday', '>= 0.9.0.rc'
  s.add_dependency 'psych', '>= 2.0.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'bundler', '>= 1.0'
  s.add_development_dependency 'rspec', '>= 2.11'
  s.add_development_dependency 'webmock', '>= 1.13.0'
  s.add_development_dependency 'pry-debugger'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
end
