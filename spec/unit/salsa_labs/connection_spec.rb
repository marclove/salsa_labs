require 'spec_helper'

describe SalsaLabs::Connection do
  let(:email){ 'jane@doe.com' }
  let(:password){ 'password' }
  let(:connection){ SalsaLabs::Connection.new(email,password) }

  # Response Object Doubles
  let(:auth_response){ double('AuthenticationResponse', :successful? => true, :session_cookies => 'JSESSIONID=sessionid') }
  let(:failed_auth_response){ double('AuthenticationResponse', :successful? => false, :error_message => 'failed auth') }
  let(:api_response){ double('ApiResponse', :successful? => true, :data => 'result') }
  let(:expired_api_response){ double('ApiResponse', :successful? => false, :needs_reauthentication? => true) }

  before do
    @auth_request = stub_request(:get, 'https://sandbox.salsalabs.com/api/authenticate.sjs').
      with(query: {email: email, password: password})

    @api_request = stub_request(:get, 'https://sandbox.salsalabs.com/api/getObjects.sjs').
      with(query: {object: 'supporter'})
  end

  describe 'without an active session' do
    before do
      connection.stub(:authenticated?){ false }
    end

    it 'makes an authentication request first, then processes the request' do
      expect(SalsaLabs::AuthenticationResponse).to receive(:new).and_return(auth_response)
      expect(SalsaLabs::ApiResponse).to receive(:new).and_return(api_response)
      connection.request('api/getObjects.sjs', {object: 'supporter'}) do |response|
        expect(response).to eq('result')
      end
      expect(@auth_request).to have_been_requested
      expect(@api_request).to have_been_requested
    end
  end

  describe 'with active, authenticated session' do
    before do
      connection.stub(:authenticated?){ true }
    end

    it 'processes the request' do
      expect(SalsaLabs::ApiResponse).to receive(:new).and_return(api_response)
      connection.request('api/getObjects.sjs', {object: 'supporter'}) do |response|
        expect(response).to eq('result')
      end
      expect(@auth_request).to_not have_been_requested
      expect(@api_request).to have_been_requested
    end
  end

  describe 'with an expired session' do
    before do
      connection.stub(:authenticated?){ true }
    end

    it 'handles the request error, authenticates, and then processes the request' do
      expect(SalsaLabs::ApiResponse).to receive(:new).and_return(expired_api_response, api_response)
      expect(SalsaLabs::AuthenticationResponse).to receive(:new).and_return(auth_response)
      connection.request('api/getObjects.sjs', {object: 'supporter'}) do |response|
        expect(response).to eq('result')
      end
      expect(@auth_request).to have_been_requested
      expect(@api_request).to have_been_requested.twice
    end

    it 'breaks an infinite reauthentication loop caused by an API response that is never valid' do
      expect(SalsaLabs::ApiResponse).to receive(:new).and_return(expired_api_response).twice
      expect(SalsaLabs::AuthenticationResponse).to receive(:new).and_return(auth_response)
      expect{ connection.request('api/getObjects.sjs', {object: 'supporter'}) }.to raise_error(SalsaLabs::AuthenticationLoopError)
      expect(@auth_request).to have_been_requested
      expect(@api_request).to have_been_requested.twice
    end

    it 'breaks an infinite reauthentication loop caused by an authentication response that is never valid' do
      expect(SalsaLabs::ApiResponse).to receive(:new).and_return(expired_api_response)
      expect(SalsaLabs::AuthenticationResponse).to receive(:new).and_return(failed_auth_response)
      expect{ connection.request('api/getObjects.sjs', {object: 'supporter'}) }.to raise_error(SalsaLabs::AuthenticationError)
      expect(@auth_request).to have_been_requested
      expect(@api_request).to have_been_requested
    end
  end
end
