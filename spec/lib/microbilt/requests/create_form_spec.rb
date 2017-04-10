require './spec/spec_helper'

RSpec.describe Microbilt::Requests::CreateForm do
  let(:options) {
    {
      callback_url: 'http://example.org/callback',
      final_url: 'http://example.org/final',
      contact_by: :neither,
      do_not_request_phones: true,
      callback_type: :json
    }
  }

  let(:customer) { FactoryGirl.build(:customer) }

  let(:create_form) { Microbilt::Requests::CreateForm.new(options) }

  before(:each) {
    Microbilt.configure do |config|
      config.client_id = ENV['MICROBILT_CLIENT_ID']
      config.client_password = ENV['MICROBILT_CLIENT_PW']
    end
  }

  describe '#to_params' do
    it 'returns the correct values' do
      p = create_form.to_params
      expect(p['CallbackUrl']).to match /callback/
      expect(p['CallbackType']).to eq 'json'
      expect(p['FinalURL']).to match /final/
      expect(p['ContactBy']).to eq 'NEITHER'
      expect(p['DoNotRequestPhones']).to eq 'true'
    end
  end

  describe '#call' do
    context 'valid parameters' do
      it 'returns a properly formatted response' do
        response = create_form.call(customer)
        expect(response[:status]).to eq :ok
        expect(response[:success]).to eq true
        expect(response[:token]).to match /[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}/

        expect(response[:add_customer_form_url]).to match /https\:\/\//i
        expect(response[:add_customer_form_url]).to match /#{response[:token]}/
        expect(response[:add_customer_form_url]).to match /#{Microbilt::Configuration::ADD_CUSTOMER_URI}/

        expect(response[:get_data_url]).to match /https\:\/\//i
        expect(response[:get_data_url]).to match /#{response[:token]}/
        expect(response[:get_data_url]).to match /#{Microbilt::Configuration::GET_DATA_URI}/

        expect(response[:get_html_data_url]).to match /https\:\/\//i
        expect(response[:get_html_data_url]).to match /#{response[:token]}/
        expect(response[:get_html_data_url]).to match /#{Microbilt::Configuration::GET_HTML_DATA_URI}/

        expect(response[:http_response][:status]).to eq 200
        expect(response[:http_response][:body].empty?).to eq false
      end
    end

    context 'invalid account credentials' do
      it 'returns a properly formatted error response' do
        Microbilt.configuration.client_id = 'ABC'
        Microbilt.configuration.client_password = '123'

        response = create_form.call(customer)
        expect(response[:status]).to eq :error
        expect(response[:success]).to eq false
        expect(response[:token]).to be_nil

        expect(response[:add_customer_form_url]).to be_nil
        expect(response[:get_data_url]).to be_nil

        expect(response[:http_response][:status]).to eq 500
        expect(response[:http_response][:body].empty?).to eq false
      end
    end

  end
end
