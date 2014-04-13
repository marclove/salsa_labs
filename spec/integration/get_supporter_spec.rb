require 'spec_helper'

describe 'GET Supporter', type: :integration do
  subject { SalsaLabs::Supporter.get('31757704') }

  it 'returns a hash' do
    expect(subject).to be_a(Hash)
  end

  it 'returns the correct record' do
    expect(subject.key?('supporter_KEY')).to be_true
    expect(subject['supporter_KEY']).to eq('31757704')
  end
end
