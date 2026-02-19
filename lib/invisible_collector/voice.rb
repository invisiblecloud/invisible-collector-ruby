# frozen_string_literal: true

require 'faraday'

module InvisibleCollector
  class Voice
    VOICE_API = 'https://link.invisiblecollector.com'

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

    def email(options = {})
      resources[:alarm] ||= Resources::EmailResource.new({ connection: connection }.merge(options))
      resources[:alarm]
    end

    def sms(options = {})
      resources[:alarm] ||= Resources::SmsResource.new({ connection: connection }.merge(options))
      resources[:alarm]
    end

    def vms(options = {})
      resources[:alarm] ||= Resources::VmsResource.new({ connection: connection }.merge(options))
      resources[:alarm]
    end

    def resources
      @resources ||= {}
    end

    private

    def connection_options
      { url: @host || VOICE_API,
        headers: { content_type: 'application/json',
                   'User-Agent' => "InvisibleCollector Ruby v#{InvisibleCollector::VERSION}",
                   'Authorization' => "Bearer #{api_token}" } }
    end
  end
end
