require 'spec_helper'

describe SalsaLabs::ApiResponse do
  # API Response Bodies
  let(:api_success) { fixture_file 'supporters.txt' }
  let(:api_delete) { fixture_file 'supporter/supporter_delete.txt' }
  let(:expired_session) { fixture_file 'expired_session.txt' }
  let(:malformed_response) { fixture_file 'malformed_response.txt' }
  let(:api) { Faraday.new(url: 'https://sandbox.salsalabs.com/api') }

  describe 'successful request' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/getObjects.sjs').
        with(query: {object: 'supporter'}).
        to_return(api_success)
      @response = SalsaLabs::ApiResponse.new(api.get('getObjects.sjs', {object: 'supporter'}))
    end

    it 'is successful' do
      expect(@response.successful?).to be_true
    end

    it 'does not need reauthentication' do
      expect(@response.needs_reauthentication?).to be_false
    end

    it 'has a parsed body' do
      expect(@response.body).to_not be_nil
      expect(@response.body).to be_an_instance_of(::Nokogiri::XML::Document)
    end

    it 'has data' do
      expect(@response.data).to_not be_nil
      expect(@response.data).to be_an_instance_of(String)
    end

    it 'has no error' do
      expect(@response.error_message).to be_nil
    end
  end

  describe 'delete request' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/delete').
        with(query: {object: 'supporter', key: '1234'}).
        to_return(api_delete)
      @response = SalsaLabs::ApiResponse.new(api.get('delete', {object: 'supporter', key: '1234'}))
    end

    it 'is successful' do
      expect(@response).to be_successful
    end

    it 'does not need reauthentication' do
      expect(@response.needs_reauthentication?).to be_false
    end

    it 'has no error' do
      expect(@response.error_message).to be_nil
    end
  end

  describe 'expired session' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/getObjects.sjs').
        with(query: {object: 'supporter'}).
        to_return(expired_session)
      @response = SalsaLabs::ApiResponse.new(api.get('getObjects.sjs', {object: 'supporter'}))
    end

    it 'is not successful' do
      expect(@response.successful?).to be_false
    end

    it 'needs reauthentication' do
      expect(@response.needs_reauthentication?).to be_true
    end

    it 'has an error message that indicates the session has expired' do
      expect(@response.error_message).to eq('There was a problem with your submission.  Please authenticate in order to continue.')
    end
  end

  describe 'unexpected response' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/getObjects.sjs').
        with(query: {object: 'supporter'}).
        to_return(malformed_response)
      @response = SalsaLabs::ApiResponse.new(api.get('getObjects.sjs', {object: 'supporter'}))
    end

    it 'is not successful' do
      expect(@response.successful?).to be_false
    end

    it 'does not need reauthentication' do
      expect(@response.needs_reauthentication?).to be_false
    end

    it 'has an error message that indicates the session has expired' do
      expect(@response.error_message).to eq('The response was not formatted as expected.')
    end
  end
end