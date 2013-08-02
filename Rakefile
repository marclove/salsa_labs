require 'bundler'
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'salsa_labs/version'

task :gem => :build
task :build do
  system 'gem build salsa_labs.gemspec'
end

task :install => :build do
  system "gem install salsa_labs-#{SalsaLabs::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{SalsaLabs::VERSION} -m 'Tagging #{SalsaLabs::VERSION}"
  system "git push --tags"
  system "gem push salsa_labs-#{SalsaLabs::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.pattern = './spec{,/*/**}/*_spec.rb'
  t.ruby_opts = "-w -I ./spec -rspec_helper"
end

# RSpec::Core::RakeTask.new(:request_spec) do |t|
#   t.verbose = false
#   t.pattern = './spec{,/*/**}/*_spec.rb'
#   t.ruby_opts = "-w -I ./spec -rspec_helper"
# end

task :default => :spec
