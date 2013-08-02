module SalsaLabs
  class ApiResponse
    def initialize(faraday_response)
      @response = faraday_response
    end

    def successful?
      data && !error_message
    end

    def needs_reauthentication?
      return false unless error
      error =~ /Please authenticate in order to continue./
    end

    def body
      @body ||= Nokogiri::XML(@response.body)
    end

    def error_message
      if data.nil?
        'The response was not formatted as expected.'
      elsif error
        error
      else
        nil
      end
    end

    def data
      data = body.xpath('//data')
      data.children.length == 0 ? nil : data.children.to_s
    end    

    def error
      err = body.xpath('//data/error').text
      err == '' ? nil : err
    end    
  end
end
