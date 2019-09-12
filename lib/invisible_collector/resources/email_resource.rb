# frozen_string_literal: true

module InvisibleCollector
  module Resources
    class EmailResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(404) { |response| raise InvisibleCollector::NotFound.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def find(params = {})
        response = execute_get('email/find', params)
        Response.new(response, Model::EmailList.new(JSON.parse(response.body).deep_transform_keys(&:underscore)))
      end

      def get(id, attrs = {})
        response = @connection.get("email/#{id}", attrs)
        if response.status == 404
          nil
        else
          build_response(response)
        end
      end

      private

      def build_response(response)
        body = Model::Email.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, body)
      end
    end
  end
end
