
require 'spec_helper'

describe SalsaLabs::Supporter do
  context 'request methods' do
    before do
      expect(SalsaLabs).to receive(:request).with(path, params).and_yield(response)
    end

    describe '#all' do
      let(:path){ 'api/getObjects.sjs' }
      let(:params){ { :object => 'supporter' } }
      let(:response){ fixture_file 'supporter/supporter_all.xml' }
      let(:expected) do
        [
          {"supporter_KEY"=>"99999999", "organization_KEY"=>"99999", "chapter_KEY"=>"0", "Last_Modified"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Date_Created"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Title"=>nil, "First_Name"=>"Jane", "MI"=>nil, "Last_Name"=>"Doe", "Suffix"=>nil, "Email"=>nil, "Password"=>nil, "Receive_Email"=>"1", "Email_Status"=>nil, "Email_Preference"=>nil, "Soft_Bounce_Count"=>nil, "Hard_Bounce_Count"=>nil, "Last_Bounce"=>nil, "Receive_Phone_Blasts_BOOLVALUE"=>"false", "Receive_Phone_Blasts"=>"false", "Phone"=>"4159999999", "Cell_Phone"=>nil, "Phone_Provider"=>nil, "Work_Phone"=>nil, "Pager"=>nil, "Home_Fax"=>nil, "Work_Fax"=>nil, "Street"=>nil, "Street_2"=>nil, "Street_3"=>nil, "City"=>nil, "State"=>nil, "Zip"=>"11111", "PRIVATE_Zip_Plus_4"=>"0000", "County"=>nil, "District"=>nil, "Country"=>nil, "Latitude"=>nil, "Longitude"=>nil, "Organization"=>nil, "Department"=>nil, "Occupation"=>nil, "Instant_Messenger_Service"=>nil, "Instant_Messenger_Name"=>nil, "Web_Page"=>nil, "Alternative_Email"=>nil, "Other_Data_1"=>nil, "Other_Data_2"=>nil, "Other_Data_3"=>nil, "Notes"=>nil, "Source"=>"Web", "Source_Details"=>"http://sandbox.wiredforchange.com/o/17270/p/dia/action3/common/public/?action_KEY=425", "Source_Tracking_Code"=>"(No Original Source Available)", "Tracking_Code"=>nil, "Status"=>nil, "uid"=>nil, "Timezone"=>nil, "Language_Code"=>nil, "fbuid"=>nil, "fbtoken"=>nil, "last_action_dedication"=>nil, "split_atom_face_pic"=>nil, "key"=>"99999999", "object"=>"supporter"},
          {"supporter_KEY"=>"88888888", "organization_KEY"=>"99999", "chapter_KEY"=>"0", "Last_Modified"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Date_Created"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Title"=>nil, "First_Name"=>"Jane", "MI"=>nil, "Last_Name"=>"Doe", "Suffix"=>nil, "Email"=>nil, "Password"=>nil, "Receive_Email"=>"1", "Email_Status"=>nil, "Email_Preference"=>nil, "Soft_Bounce_Count"=>nil, "Hard_Bounce_Count"=>nil, "Last_Bounce"=>nil, "Receive_Phone_Blasts_BOOLVALUE"=>"false", "Receive_Phone_Blasts"=>"false", "Phone"=>"4158888888", "Cell_Phone"=>nil, "Phone_Provider"=>nil, "Work_Phone"=>nil, "Pager"=>nil, "Home_Fax"=>nil, "Work_Fax"=>nil, "Street"=>nil, "Street_2"=>nil, "Street_3"=>nil, "City"=>nil, "State"=>nil, "Zip"=>"22222", "PRIVATE_Zip_Plus_4"=>"0000", "County"=>nil, "District"=>nil, "Country"=>nil, "Latitude"=>nil, "Longitude"=>nil, "Organization"=>nil, "Department"=>nil, "Occupation"=>nil, "Instant_Messenger_Service"=>nil, "Instant_Messenger_Name"=>nil, "Web_Page"=>nil, "Alternative_Email"=>nil, "Other_Data_1"=>nil, "Other_Data_2"=>nil, "Other_Data_3"=>nil, "Notes"=>nil, "Source"=>"Web", "Source_Details"=>"http://sandbox.wiredforchange.com/o/17270/p/dia/action3/common/public/?action_KEY=425", "Source_Tracking_Code"=>"(No Original Source Available)", "Tracking_Code"=>nil, "Status"=>nil, "uid"=>nil, "Timezone"=>nil, "Language_Code"=>nil, "fbuid"=>nil, "fbtoken"=>nil, "last_action_dedication"=>nil, "split_atom_face_pic"=>nil, "key"=>"88888888", "object"=>"supporter"}
        ]
      end

      specify { expect(SalsaLabs::Supporter.all).to eq(expected) }
    end

    describe '#get' do
      let(:path){ 'api/getObject.sjs' }
      let(:params){ { :object => 'supporter', :key => '99999999' } }
      let(:response){ fixture_file 'supporter/supporter_get.xml' }
      let(:expected) do
        {"supporter_KEY"=>"99999999", "organization_KEY"=>"99999", "chapter_KEY"=>"0", "Last_Modified"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Date_Created"=>"Tue Aug 10 2010 15:13:10 GMT-0400 (EDT)", "Title"=>nil, "First_Name"=>"Jane", "MI"=>nil, "Last_Name"=>"Doe", "Suffix"=>nil, "Email"=>nil, "Password"=>nil, "Receive_Email"=>"1", "Email_Status"=>nil, "Email_Preference"=>nil, "Soft_Bounce_Count"=>nil, "Hard_Bounce_Count"=>nil, "Last_Bounce"=>nil, "Receive_Phone_Blasts_BOOLVALUE"=>"false", "Receive_Phone_Blasts"=>"false", "Phone"=>"4159999999", "Cell_Phone"=>nil, "Phone_Provider"=>nil, "Work_Phone"=>nil, "Pager"=>nil, "Home_Fax"=>nil, "Work_Fax"=>nil, "Street"=>nil, "Street_2"=>nil, "Street_3"=>nil, "City"=>nil, "State"=>nil, "Zip"=>"11111", "PRIVATE_Zip_Plus_4"=>"0000", "County"=>nil, "District"=>nil, "Country"=>nil, "Latitude"=>nil, "Longitude"=>nil, "Organization"=>nil, "Department"=>nil, "Occupation"=>nil, "Instant_Messenger_Service"=>nil, "Instant_Messenger_Name"=>nil, "Web_Page"=>nil, "Alternative_Email"=>nil, "Other_Data_1"=>nil, "Other_Data_2"=>nil, "Other_Data_3"=>nil, "Notes"=>nil, "Source"=>"Web", "Source_Details"=>"http://sandbox.wiredforchange.com/o/17270/p/dia/action3/common/public/?action_KEY=425", "Source_Tracking_Code"=>"(No Original Source Available)", "Tracking_Code"=>nil, "Status"=>nil, "uid"=>nil, "Timezone"=>nil, "Language_Code"=>nil, "fbuid"=>nil, "fbtoken"=>nil, "last_action_dedication"=>nil, "split_atom_face_pic"=>nil, "key"=>"99999999", "object"=>"supporter"}
      end

      specify { expect(SalsaLabs::Supporter.get('99999999')).to eq(expected) }
    end

    describe '#count' do
      let(:path){ 'api/getCounts.sjs' }
      let(:params){ { :object => 'supporter' } }
      let(:response){ fixture_file 'supporter/supporter_count.xml' }
      let(:expected){ 12 }

      specify { expect(SalsaLabs::Supporter.count).to eq(expected) }
    end

    describe '#save' do
      let(:path){ 'save' }
      let(:params){ { :object => 'supporter', :Phone => '4159876543' } }
      let(:response){ fixture_file 'supporter/supporter_save.xml' }
      let(:expected){ '12345678' }

      specify { expect(SalsaLabs::Supporter.save(:Phone => '4159876543')).to eq(expected) }
    end

    describe '#delete' do
      let(:path){ 'delete' }
      let(:params){ { :object => 'supporter', :key => '1234' } }
      let(:response){ fixture_file 'supporter/supporter_delete.txt' }

      specify { expect(SalsaLabs::Supporter.delete('1234')).to be_true }
    end
  end
end
