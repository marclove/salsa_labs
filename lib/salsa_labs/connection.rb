require 'net/http'
require 'cgi'
require 'faraday'

module SalsaLabs
  class APIResponseError < StandardError; end
  class AuthenticationError < StandardError; end
  class AuthenticationLoopError < StandardError; end

  class Connection
    def initialize(email, password)
      @email, @password = email, password
      @authentication_headers = {}
    end

    def request(path, params={}, recursive_call = false, &block)
      authenticate unless authenticated?

      execute_request(path, params) do |response|
        if response.successful?
          block.call(response.data)
        elsif response.needs_reauthentication?
          raise AuthenticationLoopError.new if recursive_call
          authenticate
          request(path, params, true, &block)
        else
          raise APIResponseError, response.error_message
        end
      end 
    end
    
    private

    def api
      @api ||= ::Faraday.new(url: 'https://sandbox.salsalabs.com/api')
    end

    def execute_request(path, params={})
      yield ApiResponse.new(api.get(path, params, @authentication_headers))
    end

    def authenticate
      email, password = CGI.escape(@email), CGI.escape(@password)
      auth_path = "authenticate.sjs?email=#{email}&password=#{password}"
      response = AuthenticationResponse.new(api.get(auth_path))
      if response.successful?
        @authentication_headers = response.session_cookies
      else
        raise AuthenticationError, response.error_message
      end
    end
        
    def authenticated?
      @authentication_headers.has_key?('JSESSIONID')
    end
  end
end
