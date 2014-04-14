module SalsaLabs
  class SaveResponse
    # @param [String] an xml string of the response body
    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      raise APIResponseError, 'Save request failed' unless successful?
    end

    # @return [Boolean] true if request was successful
    def successful?
      success_object? && key_returned?
    end

    # @return [String] the key of the object that was saved
    def key
      @doc.xpath('/success').attr('key').to_s
    end

    private

    def success_object?
      @doc.xpath('/success').length > 0
    end

    def key_returned?
      !key.blank?
    end
  end
end