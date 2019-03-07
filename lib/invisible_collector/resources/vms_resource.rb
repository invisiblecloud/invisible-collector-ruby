module InvisibleCollector
  module Resources
    class VmsResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(404) { |response| raise InvisibleCollector::NotFound.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def get(id, attrs = {})
        response = @connection.get("vms/#{id}", attrs)
        if response.status == 404
          nil
        else
          build_response(response)
        end
      end

      def save(sms)
        response = execute_post('vms', sms)
        build_list_response(response)
      end

      private

      def build_list_response(response)
        body = JSON.parse(response.body).map { |j| Model::Vms.new(j.deep_transform_keys(&:underscore)) }
        Response.new(response, body)
      end

      def build_response(response)
        body = Model::Vms.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, body)
      end
    end
  end
end
