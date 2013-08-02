require 'spec_helper'

describe SalsaLabs::AuthenticationResponse do
  let(:email){ 'jane@doe.com' }
  let(:password){ 'password' }

  # API Response Bodies
  let(:auth_success) { File.new(File.join(File.dirname(__FILE__),'..','fixtures','auth_success.txt')) }
  let(:auth_failure) { File.new(File.join(File.dirname(__FILE__),'..','fixtures','auth_error.txt')) }
  let(:api) { Faraday.new(url: 'https://sandbox.salsalabs.com/api') }

  describe 'successful authentication' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/authenticate.sjs').
        with(query: {email: email, password: password}).
        to_return(auth_success)
      @response = SalsaLabs::AuthenticationResponse.new(api.get('authenticate.sjs', {email: email, password: password}))
    end
    
    it 'knows that it is successful' do
      expect(@response.successful?).to be_true
    end
    
    it "has a session cookie" do
      expect(@response.session_cookies).to eq({'JSESSIONID' => 'A1737DC1330748B01456B3C269162AB6-n3'})
    end
    
    it "has no error" do
      expect(@response.error_message).to be_nil
    end
  end
  
  describe 'failed authentication' do
    before do
      stub_request(:get, 'https://sandbox.salsalabs.com/api/authenticate.sjs').
        with(query: {email: email, password: password}).
        to_return(auth_failure)
      @response = SalsaLabs::AuthenticationResponse.new(api.get('authenticate.sjs', {email: email, password: password}))
    end
    
    it 'knows that it was not successful' do
      expect(@response.successful?).to be_false
    end
    
    it "has no session cookie" do
      expect(@response.session_cookies).to eq({})
    end
    
    it "has the response's headers" do
      expect(@response.error_message).to eq('Invalid login, please try again.')
    end
  end
end
