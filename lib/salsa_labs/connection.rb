require 'net/http'
require 'cgi'
require 'faraday'

module SalsaLabs
  class APIResponseError < StandardError; end
  class AuthenticationError < StandardError; end
  class AuthenticationLoopError < StandardError; end

  class Connection

    # @param [String] email
    #   from your Salsa Labs login
    # @param [String] password
    #   from your Salsa Labs login
    def initialize(email, password)
      @email, @password = email, password
      @authentication_headers = {}
    end

    # @param [String] path
    #   the url fragment that follows "+sandbox.salsalabs.com/api/+"
    #   in the endpoint uri you are making a request to
    # @param [Hash] query
    #   a hash representing the url query string parameters
    # @param [Boolean] recursive_call
    #   whether this method was called by itself
    # @yield
    #   the code to execute if the response is successful
    # @yieldparam [String] response
    #   the xml fragment contained in the +<data></data>+ element of the API response
    # @raise [AuthenticationLoopError]
    #   if the request is caught in an infinite authentication loop
    # @raise [APIResponseError]
    #   if the API response returned an error or was malformed
    def request(path, query={}, recursive_call = false, &block)
      authenticate unless authenticated?

      execute_request(path, query) do |response|
        if response.successful?
          block.call(response.data)
        elsif response.needs_reauthentication?
          raise AuthenticationLoopError.new if recursive_call
          authenticate
          request(path, query, true, &block)
        else
          raise APIResponseError, response.error_message
        end
      end
    end

    private

    # @return [Faraday]
    def api
      @api ||= ::Faraday.new(url: 'https://sandbox.salsalabs.com/api')
    end

    # @yieldparam [ApiResponse] response
    def execute_request(path, query={})
      yield ApiResponse.new(api.get(path, query, @authentication_headers))
    end

    # Makes an authentication call to the Salsa Labs API using the credentials
    # set in the {SalsaLabs.configure} method.
    #
    # @raise [AuthenticationError] if the response returned an error or is malformed
    def authenticate
      email, password = CGI.escape(@email), CGI.escape(@password)
      auth_path = "authenticate.sjs?email=#{email}&password=#{password}"
      response = AuthenticationResponse.new(api.get(auth_path))
      if response.successful?
        @authentication_headers = { 'Cookie' => response.session_cookies }
      else
        @authentication_headers = nil
        raise AuthenticationError, response.error_message
      end
    end

    # Returns +true+ if the session cookie has been set.
    #
    # @return [Boolean]
    def authenticated?
      !!@authentication_headers
    end
  end
end
