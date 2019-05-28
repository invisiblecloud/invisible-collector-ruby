# frozen_string_literal: true

module InvisibleCollector
  module Resources
    class CompanyResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
      end

      def get
        build_response(@connection.get('companies'))
      end

      def update(company)
        build_response(@connection.put('companies', company))
      end

      def enable_notifications
        build_response(@connection.put('/companies/enableNotifications'))
      end

      def disable_notifications
        build_response(@connection.put('/companies/disableNotifications'))
      end

      private

      def build_response(response)
        company = Model::Company.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, company)
      end
    end
  end
end
