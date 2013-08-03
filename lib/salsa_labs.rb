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
    # @!attribute [r] message
    # @return [String]
    #   the error message
    def message
      'You have not properly configured SalsaLabs with your email and password'
    end
  end

  # Configures the gem with your Salsa Labs credentials
  # @note Configuration is required for the gem to function.
  # @yieldparam [SalsaLabs::Configuration] config
  #   yields gem's current +Configuration+ object within the block
  # @example
  #   SalsaLabs.configure do |c|
  #     c.email    = 'myemail@example.com'
  #     c.password = 'mypassword'
  #   end
  # @return [SalsaLabs]
  # @see SalsaLabs::Configuration
  def self.configure
    yield configuration
  end

  # Makes a request to the specified SalsaLabs API endpoint.
  # @param [String] path
  #   the url fragment that follows "+sandbox.salsalabs.com/api/+"
  #   in the endpoint uri you are making a request to
  # @param [Hash] query
  #   a hash representing the url query string parameters
  # @yieldreturn [SalsaLabs::ApiResponse]
  #   the response object for the executed request
  # @return [SalsaLabs]
  def self.request(path, query={}, &block)
    connection.request(path, query, &block)
  end

  private

  # @return [SalsaLabs::Configuration]
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @return [SalsaLabs::Connection]
  def self.connection
    @connection ||= establish_connection
  end

  # @return [SalsaLabs::Connection]
  # @raise [ConfigurationError] if the gem has not been configured properly
  def self.establish_connection
    raise ConfigurationError.new unless configuration.valid?
    Connection.new(configuration.email, configuration.password)
  end
end
