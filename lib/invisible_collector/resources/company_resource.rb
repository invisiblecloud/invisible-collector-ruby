module InvisibleCollector
  module Resources
    class CompanyResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
      end

      def get
        Model::Company.new(JSON.parse(@connection.get('companies').body).deep_transform_keys(&:underscore))
      end

      def update(company)
        Model::Company.new(JSON.parse(@connection.put('companies', company).body).deep_transform_keys(&:underscore))
      end

      def enable_notifications
        Model::Company.new(JSON.parse(@connection.put('/companies/enableNotifications').body)
                        .deep_transform_keys(&:underscore))
      end

      def disable_notifications
        Model::Company.new(JSON.parse(@connection.put('/companies/disableNotifications').body)
                        .deep_transform_keys(&:underscore))
      end
    end
  end
end
