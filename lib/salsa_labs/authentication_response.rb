require 'nokogiri'

module SalsaLabs
  class AuthenticationResponse

    # @param [Faraday::Response] faraday_response
    def initialize(faraday_response)
      @response = faraday_response
    end

    # @return [Hash]
    def session_cookies
      if successful?
        cookies = @response.headers['set-cookie'].split(/;\s*/)
        cookie = cookies.find{ |s| s =~ /JSESSION/ }.split('=')
        Hash[*cookie] if cookie
      else
        Hash[]
      end
    end

    # @return [Boolean] true if no error message was returned
    def successful?
      !error_message
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
  end
end
