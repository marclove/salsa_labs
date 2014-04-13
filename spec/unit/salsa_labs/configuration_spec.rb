require 'spec_helper'

describe SalsaLabs::Configuration do
  let(:config){ SalsaLabs::Configuration.new }
  
  it 'is configurable' do
    expect(config).to respond_to(:email=)
    expect(config).to respond_to(:password=)
  end
  
  it 'is readable' do
    expect(config).to respond_to(:email)
    expect(config).to respond_to(:password)
  end
  
  it 'is invalid if email is blank' do
    config.email = nil
    config.password = 'password'
    expect(config.valid?).to be_false
  end
  
  it 'is invalid if password is blank' do
    config.email = 'jane@doe.com'
    config.password = nil
    expect(config.valid?).to be_false
  end
  
  it 'is valid if email and password are set' do
    config.email = 'jane@doe.com'
    config.password = 'password'
    expect(config.valid?).to be_true
  end
end
