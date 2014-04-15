require 'spec_helper'

describe 'POST Supporter', type: :integration do
  subject do
    SalsaLabs::Supporter.save(
      :First_Name => 'IntegrationSpec',
      :Last_Name => Time.now.to_i.to_s
    )
  end

  it 'saves the supporter' do
    expect(subject).to be_a(String)
    saved_object = SalsaLabs::Supporter.get(subject)
    expect(subject).to eq(saved_object['key'])
  end
end
