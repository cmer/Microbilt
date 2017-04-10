module Microbilt
  module Requests
    class CreateForm
      include Microbilt::Requests::Helpers

      attr_accessor :callback_url, :final_url
      attr_reader   :contact_by, :do_not_request_phones, :callback_type

      def initialize(options = nil)
        options.keys.each do |k|
          self.send("#{k}=", options[k])
        end if options

        do_not_request_phones = false if do_not_request_phones.nil?
      end

      def to_params
        {
          'CallbackUrl' => callback_url,
          'CallbackType' => callback_type.to_s,
          'FinalURL' => final_url,
          'ContactBy' => contact_by.to_s.upcase,
          'DoNotRequestPhones' => do_not_request_phones.to_s
        }
      end

      def call(customer)
        response = http_connection.post do |req|
          req.url Microbilt::Configuration::CREATE_FORM_URI
          req.headers['Content-Type'] = Microbilt::Configuration::CONTENT_TYPE
          req.params = all_params(customer)
        end

        handle_response(response)
      end

      private

      def handle_response(response)
        output = output_template(response)

        if output[:status] == :ok
          token = parse_token(response.body)
          output[:token] = token
          output[:add_customer_form_url] = add_customer_url(token)
          output[:get_data_url] = get_data_url(token)
          output[:get_html_data_url] = get_html_data_url(token)
        end

        output
      end

      def output_template(response)
        status = response.status.to_i

        if status.between?(200, 299)
          status = :ok
        elsif status.between?(300, 399)
          status = :redirect
        elsif status.between?(400, 599)
          status = :error
        end

        {
          success: status == :ok,
          status: status,
          http_response: {
            status: response.status,
            body: response.body
          }
        }
      end

      def parse_token(response_body)
        response_body.match(/{(.*)}/)[1]
      end

      def add_customer_url(token)
        "#{Microbilt.configuration.server_url}#{Microbilt::Configuration::ADD_CUSTOMER_URI}?reference=#{token}"
      end

      def get_data_url(token)
        "#{Microbilt.configuration.server_url}#{Microbilt::Configuration::GET_DATA_URI}?reference=#{token}"
      end

      def get_html_data_url(token)
        "#{Microbilt.configuration.server_url}#{Microbilt::Configuration::GET_HTML_DATA_URI}?guid=#{token}"
      end

      def all_params(customer)
        to_params.merge(Microbilt.configuration.to_params).merge(customer.to_params)
      end

      # Setters
      def contact_by=(value)
        raise ArgumentError.new("Invalid value: #{value}") unless
           %i(sms email both neither).include?(value.to_sym)

        @contact_by = value.to_sym
      end

      def do_not_request_phones=(value)
        raise ArgumentError.new("Invalid value: #{value}") unless
          value.is_a?(TrueClass) || value.is_a?(Falseclass)

        @do_not_request_phones = value
      end

      def callback_type=(value)
        raise ArgumentError.new("Invalid value: #{value}") unless
          %i(json xml).include?(value.to_sym)

        @callback_type = value.to_sym
      end

    end
  end
end
