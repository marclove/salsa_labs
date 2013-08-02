require 'salsa_labs/configuration'
require 'salsa_labs/connection'
require 'salsa_labs/authentication_response'
require 'salsa_labs/api_response'
require 'salsa_labs/salsa_object'
require 'salsa_labs/objects/distributed_event'
require 'salsa_labs/objects/donation'
require 'salsa_labs/objects/event'
require 'salsa_labs/objects/groups'
require 'salsa_labs/objects/supporter_action_comment'
require 'salsa_labs/objects/supporter_action_content'
require 'salsa_labs/objects/supporter_action_target'
require 'salsa_labs/objects/supporter_action'
require 'salsa_labs/objects/supporter_event'
require 'salsa_labs/objects/supporter_groups'
require 'salsa_labs/objects/supporter'

module SalsaLabs
  class ConfigurationError < StandardError
    def message
      'You have not properly configured SalsaLabs with your email and password'
    end
  end

  # SalsaLabs.configure do |c|
  #   c.email    = 'myemail@example.com'
  #   c.password = 'mypassword'
  # end
  def self.configure
    yield configuration
  end

  def self.request(path, params={}, &block)
    connection.request(path, &block)
  end

  private

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.connection
    @connection ||= establish_connection
  end

  def self.establish_connection
    raise ConfigurationError.new unless configuration.valid?
    Connection.new(configuration.email, configuration.password)      
  end
end
