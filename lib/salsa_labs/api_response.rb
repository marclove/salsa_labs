module SalsaLabs
  class ApiResponse

    # @param [Faraday::Response] faraday_response
    def initialize(faraday_response)
      @response = faraday_response
    end

    # @return [Boolean] true if response was properly formed and
    #   no error message was returned
    def successful?
      data && !error_message
    end

    # @return [Boolean] true if an error message is returned that
    #   indicates the current session has expired
    def needs_reauthentication?
      return false unless error
      error =~ /Please authenticate in order to continue./
    end

    # @return [Nokogiri::XML] the full xml returned by the API,
    #   parsed by +Nokogiri+ (memoized)
    def body
      @body ||= Nokogiri::XML(@response.body)
    end

    # @return [String] the error message returned by the API
    # @return [nil] if there was no error message returned by the API
    def error_message
      if data.nil?
        'The response was not formatted as expected.'
      elsif error
        error
      else
        nil
      end
    end

    # @return [String] the xml fragment contained in the
    #   +<data></data>+ element of the API response
    # @return [nil] if there was no data returned by the API
    def data
      data = body.xpath('//data')
      data.children.length == 0 ? nil : data.children.to_s
    end

    # @return [String] the error message returned by the API
    # @return [nil] if there was no error message returned by the API
    def error
      err = body.xpath('//data/error').text
      err == '' ? nil : err
    end
  end
end
