require 'spec_helper'

describe SalsaLabs do
  describe 'configuration' do
    it 'always returns the same configuration object' do
      expect(SalsaLabs.configuration).to be(SalsaLabs.configuration)
    end
    
    it 'is configurable' do
      SalsaLabs.configure do |c|
        c.email = 'jane@doe.com'
        c.password = 'password'
      end
      expect(SalsaLabs.configuration.email).to eq('jane@doe.com')
      expect(SalsaLabs.configuration.password).to eq('password')
    end
  end
  
  describe 'request handling' do
    it 'delegates requests to its connection object' do
      connection = double('Connection')
      response = double('response')
      path = '/'
      body = 'here is the body'

      expect(response).to receive(:body).and_return(body)
      expect(connection).to receive(:request).with(path).and_yield(response)
      SalsaLabs.stub(:connection){ connection }

      SalsaLabs.request(path) do |resp|
        expect(resp.body).to eq(body)
      end
    end
  end
end
