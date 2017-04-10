module Microbilt
  class Customer

    attr_accessor :first_name, :last_name, :sin, :date_of_birth, :address1, :address2,
                  :city, :state, :zip_code, :country, :home_phone, :mobile_phone,
                  :work_phone, :email, :bank_transit, :bank_account, :direct_deposit_amount,
                  :account_type, :direct_deposit_pay_cycle, :completion_email

    VALID_ACCOUNT_TYPES = { checking: 100, savings: 101, cd: 102, money_market: 103,
                            credit_card: 200, line_of_credit: 201,
                            taxable_investment: 300, tax_deferred_investment: 301,
                            mortgage: 400, loan: 401,
                            annuity: 500, whole_life: 501,
                            rewards: 600, email: 650, biller: 675,
                            term_insurance: 701, asset: 908, liability: 955, other: 999
                          }

    def initialize(options = nil)
      options.keys.each do |k|
        self.send("#{k}=", options[k])
      end if options
    end

    def to_params
      {
        'Customer.FirstName' => first_name,
        'Customer.LastName' => last_name,
        'Customer.SSN' => sin,
        'Customer.DOB' => formatted_date(date_of_birth),
        'Customer.Address' => formatted_address,
        'Customer.City' => city,
        'Customer.State' => state,
        'Customer.ZIP' => zip_code,
        'Customer.Country' => formatted_country,
        'Customer.Phone' => home_phone,
        'Customer.WorkPhone' => work_phone,
        'Customer.CellPhone' => mobile_phone,
        'Customer.Email' => email,
        'Customer.ABAnumber' => bank_transit,
        'Customer.AccountNumber' => bank_account,
        'Customer.DirectDepositAmount' => direct_deposit_amount,
        'Customer.DirectDepositPayCycle' => formatted_direct_deposit_pay_cycle,
        'Customer.CompletionEmail' => completion_email,
        'Customer.AccountType' => formatted_account_type
      }
    end

    private

    def formatted_date(d)
      d.strftime('%m%d%Y')
    end

    def formatted_address
      address = address1
      address += "\n" + address2 unless address2.to_s.empty?
      address
    end

    def microbilt_address(loan_application)
      address = loan_application.address1
      address += "\n" + loan_application.address2 if loan_application.address2.present?
      address
    end

    def formatted_country
      case country.upcase
      when 'CA'
        'CAN'
      when 'US'
        'USA'
      else
        raise ArgumentError.new "Unknown country '#{country}'"
      end
    end

    def formatted_direct_deposit_pay_cycle
      case direct_deposit_pay_cycle.to_s
      when 'weekly'
        'Every week'
      when 'biweekly'
        'Every other week'
      when 'twicemonthly'
        'Two times a month'
      when 'monthly'
        'Once a month'
      else
        direct_deposit_pay_cycle.to_s
      end
    end

    def formatted_account_type
      account_type_code = VALID_ACCOUNT_TYPES[account_type]

      if !account_type_code.nil?
        account_type_code
      elsif !account_type.nil?
        raise ArgumentError.new "Invalid account type: #{account_type}"
      else
        nil
      end
    end
  end
end
