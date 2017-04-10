require 'faraday'

module Microbilt
  module Requests
    module Helpers
      def http_connection
        Faraday.new(url: Microbilt.configuration.server_url)
      end
    end
  end
end
