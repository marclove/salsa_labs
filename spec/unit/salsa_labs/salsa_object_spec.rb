require 'spec_helper'

describe SalsaLabs::SalsaObject do
  before do
    Klass = Class.new{ include SalsaLabs::SalsaObject }
  end
  
  it 'knows its object name' do
    expect(Klass.send(:object_name)).to eq('klass')
  end
end
