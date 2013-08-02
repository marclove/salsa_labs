require 'nokogiri'

module SalsaLabs
  class AuthenticationResponse
    def initialize(faraday_response)
      @response = faraday_response
    end

    def session_cookies
      if successful?
        cookies = @response.headers['set-cookie'].split(/;\s*/)
        cookie = cookies.find{ |s| s =~ /JSESSION/ }.split('=')
        Hash[*cookie] if cookie
      else
        Hash[]
      end
    end

    def successful?
      !error_message
    end

    def body
      @body ||= ::Nokogiri::XML(@response.body)
    end

    def error_message
      err = body.xpath('//data/error').text
      err == '' ? nil : err
    end    
  end
end
