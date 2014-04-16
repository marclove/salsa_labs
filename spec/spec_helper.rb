$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'..','lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))

require 'bundler/setup'
require 'salsa_labs'
require 'rspec'
require 'webmock/rspec'
require 'support/fixtures'
require 'support/silence_warnings'

silence_warnings { require 'pry-debugger' }

RSpec.configure do |config|
  config.order = :rand

  config.include(Fixtures)

  config.around :each, type: :integration do |example|
    WebMock.disable!

    SalsaLabs.configure do |c|
      c.email    = ENV['SALSA_USERNAME']
      c.password = ENV['SALSA_PASSWORD']
    end

    example.run

    WebMock.enable!
  end
end
