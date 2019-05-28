# frozen_string_literal: true

require 'faraday'

module InvisibleCollector
  class API
    INVISIBLECOLLECTOR_API = 'https://api.invisiblecollector.com'.freeze

    attr_reader :api_token

    def initialize(options = {})
      @api_token = options.with_indifferent_access[:api_token]
      @host = options.with_indifferent_access[:host]
    end

    def connection
      @connection ||= Faraday.new connection_options do |req|
        req.adapter :net_http
      end
    end

    def alarm(options = {})
      resources[:alarm] ||= Resources::AlarmResource.new({ connection: connection }.merge(options))
      resources[:alarm]
    end

    def company(options = {})
      resources[:company] ||= Resources::CompanyResource.new({ connection: connection }.merge(options))
      resources[:company]
    end

    def customer(options = {})
      resources[:customer] ||= Resources::CustomerResource.new({ connection: connection }.merge(options))
      resources[:customer]
    end

    def debt(options = {})
      resources[:debt] ||= Resources::DebtResource.new({ connection: connection }.merge(options))
      resources[:debt]
    end

    def payment(options = {})
      resources[:payment] ||= Resources::PaymentResource.new({ connection: connection }.merge(options))
      resources[:payment]
    end

    def group(options = {})
      resources[:group] ||= Resources::GroupResource.new({ connection: connection }.merge(options))
      resources[:group]
    end

    def resources
      @resources ||= {}
    end

    private

    def connection_options
      {
        url: @host || INVISIBLECOLLECTOR_API,
        headers: {
          content_type: 'application/json',
          'User-Agent' => "InvisibleCollector Ruby v#{InvisibleCollector::VERSION}",
          'Authorization' => "Bearer #{api_token}"
        }
      }
    end
  end
end
