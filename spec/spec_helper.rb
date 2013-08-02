$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'..','lib'))

require 'bundler/setup'
require 'salsa_labs'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.order = :rand
end
