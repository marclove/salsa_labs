require 'spec_helper'

describe 'POST Supporter', type: :integration do
  subject do
    SalsaLabs::Supporter.create(
      :First_Name => 'IntegrationSpec',
      :Last_Name => Time.now.to_i.to_s
    )
  end

  it 'creates the supporter' do
    expect(subject).to be_a(String)
    created_object = SalsaLabs::Supporter.get(subject)
    expect(subject).to eq(created_object['key'])
  end
end
