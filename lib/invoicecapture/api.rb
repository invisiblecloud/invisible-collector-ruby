require 'faraday'

module InvoiceCapture

  class API

    INVOICECAPTURE_API = 'https://api.invcapture.com'

    attr_accessor :client
    attr_reader :api_token

    def initialize(option = {})
      @api_token = option[:api_token]
      @client = nil
    end

    def connection
      @faraday ||= Faraday.new connection_options do |req|
        req.adapter :net_http
      end
    end

    def company
      resources[:company] ||= CompanyResource.new(connection: connection)
      resources[:company]
    end

    def customer
      resources[:customer] ||= CustomerResource.new(connection: connection)
      resources[:customer]
    end

    def resources
      @resources ||= {}
    end

    private

    def connection_options
      {
        url: INVOICECAPTURE_API,
        headers: {
          content_type: 'application/json',
          'X-Api-Token' => api_token
        }
      }
    end

  end

end
