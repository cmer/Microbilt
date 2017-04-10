FactoryGirl.define do
  factory :customer, class: Microbilt::Customer do
    first_name 'John'
    last_name 'Smith'
    sin '123 456 789'
    date_of_birth Date.new(1980, 1, 2)
    address1 '123 Main St.'
    address2 'Apt #1234'
    city 'Toronto'
    state 'ON'
    zip_code 'M1X 1X1'
    country 'CA'
    home_phone '123-456-7890'
    mobile_phone '555-111-2222'
    work_phone '555-555-5555'
    email 'john@smith.com'
    bank_transit '12345'
    bank_account '123456789'
    account_type :checking
    direct_deposit_amount '1000'
    direct_deposit_pay_cycle :biweekly
    completion_email 'john@example.org'
  end
end
