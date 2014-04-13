require 'nokogiri'

module SalsaLabs
  class AuthenticationResponse

    # @param [Faraday::Response] faraday_response
    def initialize(faraday_response)
      @response = faraday_response
    end

    # @return [String]
    def session_cookies
      returned_cookies if successful?
    end

    # @return [Boolean] true if no error message was returned
    def successful?
      !error_message && session_cookie_exists?
    end

    # @return [Nokogiri::XML] the full xml returned by the API,
    #   parsed by +Nokogiri+ (memoized)
    def body
      @body ||= ::Nokogiri::XML(@response.body)
    end

    # @return [String] the error message returned by the API
    # @return [nil] if there was no error message returned by the API
    def error_message
      err = body.xpath('//data/error').text
      err == '' ? nil : err
    end

    private

    def session_cookie_exists?
      returned_cookies =~ /JSESSION/
    end

    def returned_cookies
      @response.headers['set-cookie']
    end
  end
end
