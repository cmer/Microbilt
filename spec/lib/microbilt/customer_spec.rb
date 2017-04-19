require './spec/spec_helper'

RSpec.describe Microbilt::Customer do
  describe '#to_params' do
    let(:options) {
      {
        first_name: 'John',
        last_name: 'Smith',
        sin: '123 456 789',
        date_of_birth: Date.new(1980, 1, 2),
        address1: '123 Main St.',
        address2: 'Apt #1234',
        city: 'Toronto',
        state: 'ON',
        zip_code: 'M1X 1X1',
        country: 'CA',
        home_phone: '123-456-7890',
        mobile_phone: '555-111-2222',
        work_phone: '555-555-5555',
        email: 'john@smith.com',
        bank_transit: '12345',
        bank_account: '123456789',
        direct_deposit_amount: '1000',
        direct_deposit_pay_cycle: :biweekly,
        completion_email: 'john@example.org',
        account_type: :checking
      }
    }

    let(:customer) { Microbilt::Customer.new(options) }

    it 'returns the correct values' do
      p = customer.to_params
      expect(p['Customer.FirstName']).to eq options[:first_name]
      expect(p['Customer.LastName']).to eq options[:last_name]
      expect(p['Customer.SSN']).to eq options[:sin].gsub(' ', '')
      expect(p['Customer.DOB']).to eq '01021980'
      expect(p['Customer.Address']).to eq options[:address1] + "\n, " + options[:address2]
      expect(p['Customer.City']).to eq options[:city]
      expect(p['Customer.State']).to eq options[:state]
      expect(p['Customer.ZIP']).to eq options[:zip_code].gsub(' ', '')
      expect(p['Customer.Country']).to eq 'CAN'
      expect(p['Customer.Phone']).to eq options[:home_phone].gsub(/[^0-9]/i, '')[0..9]
      expect(p['Customer.WorkPhone']).to eq options[:work_phone].gsub(/[^0-9]/i, '')[0..9]
      expect(p['Customer.CellPhone']).to eq options[:mobile_phone].gsub(/[^0-9]/i, '')[0..9]
      expect(p['Customer.Email']).to eq options[:email]
      expect(p['Customer.ABAnumber']).to eq options[:bank_transit]
      expect(p['Customer.AccountNumber']).to eq options[:bank_account]
      expect(p['Customer.DirectDepositAmount']).to eq options[:direct_deposit_amount]
      expect(p['Customer.DirectDepositPayCycle']).to eq 'Every other week'
      expect(p['Customer.CompletionEmail']).to eq options[:completion_email]
    end
  end
end
