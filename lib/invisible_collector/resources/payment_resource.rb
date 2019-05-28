# frozen_string_literal: true

module InvisibleCollector
  module Resources
    class PaymentResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(404) { |response| raise InvisibleCollector::NotFound.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def save(payment)
        response = execute_post('payments', payment)
        payment = Model::Payment.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, payment)
      end
    end
  end
end
