module Microbilt
  class Configuration
    PROD_SERVER_URL  = 'https://creditserver.microbilt.com'
    TEST_SERVER_URL  = 'https://sdkstage.microbilt.com'

    CREATE_FORM_URI  = '/WebServices/IBV/Home/CreateForm'
    GET_DATA_URI     = '/WebServices/IBV/Home/GetData'
    ADD_CUSTOMER_URI = '/WebServices/IBV/Home/AddCustomer'

    CONTENT_TYPE     = 'application/x-www-form-urlencoded'

    attr_accessor :client_id, :client_password, :format, :server

    def initialize
      @format = :json
      @server = :test
    end

    def to_params
      validate_credentials!

      {
        'MemberId' => client_id,
        'MemberPwd' => client_password
      }
    end

    def server_url
      server == :production ? PROD_SERVER_URL : TEST_SERVER_URL
    end

    protected

    def validate_credentials!
      raise ArgumentError.new("Invalid Client ID: #{client_id}") if client_id.to_s.empty?
      raise ArgumentError.new("Invalid Client Password: #{client_password}") if client_id.to_s.empty?
    end
  end
end
