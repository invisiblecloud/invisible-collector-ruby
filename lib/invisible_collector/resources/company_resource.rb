module InvisibleCollector
  module Resources
    class CompanyResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
      end

      def get
        response = @connection.get('companies')
        company = Model::Company.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, company)
      end

      def update(company)
        response = @connection.put('companies', company)
        company = Model::Company.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, company)
      end

      def enable_notifications
        response = @connection.put('/companies/enableNotifications')
        company = Model::Company.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, company)
      end

      def disable_notifications
        response = @connection.put('/companies/disableNotifications')
        company = Model::Company.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, company)
      end
    end
  end
end
