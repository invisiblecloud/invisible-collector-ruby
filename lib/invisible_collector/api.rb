require 'faraday'

module InvisibleCollector
  class API
    INVISIBLECOLLECTOR_API = 'https://api.invisiblecollector.com'.freeze

    attr_reader :api_token

    def initialize(option = {})
      @api_token = option.with_indifferent_access[:api_token]
    end

    def connection
      @faraday ||= Faraday.new connection_options do |req|
        req.adapter :net_http
      end
    end

    def alarm
      resources[:alarm] ||= AlarmResource.new(connection: connection)
      resources[:alarm]
    end

    def company
      resources[:company] ||= CompanyResource.new(connection: connection)
      resources[:company]
    end

    def customer
      resources[:customer] ||= CustomerResource.new(connection: connection)
      resources[:customer]
    end

    def debt
      resources[:debt] ||= DebtResource.new(connection: connection)
      resources[:debt]
    end

    def group
      resources[:group] ||= GroupResource.new(connection: connection)
      resources[:group]
    end

    def resources
      @resources ||= {}
    end

    private

    def connection_options
      {
        url: INVISIBLECOLLECTOR_API,
        headers: {
          content_type: 'application/json',
          'User-Agent' => "InvisibleCollector Ruby v#{InvisibleCollector::VERSION}",
          'Authorization' => "Bearer #{api_token}"
        }
      }
    end
  end
end
