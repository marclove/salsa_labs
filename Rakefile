require 'bundler'
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'
require 'yard'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'salsa_labs/version'

task :gem => :build
task :build do
  system 'gem build salsalabs.gemspec'
end

task :install => :build do
  system "gem install salsalabs-#{SalsaLabs::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{SalsaLabs::VERSION} -m 'Tagging #{SalsaLabs::VERSION}"
  system "git push --tags"
  system "gem push salsalabs-#{SalsaLabs::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.pattern = './spec{,/*/**}/*_spec.rb'
  t.ruby_opts = "-w -I ./spec -rspec_helper"
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['--embed-mixins', '--protected', '--private', '--readme', 'README.md']
end

task :default => :spec
