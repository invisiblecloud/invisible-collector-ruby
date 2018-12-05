module InvisibleCollector
  module Resources
    class CustomerResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def alarm(customer, params = {})
        id = customer.is_a?(Model::Customer) ? customer.gid : customer
        response = @connection.get("customers/#{id}/alarm", params)
        if response.status == 404
          Response.new(response, nil)
        elsif handles.key? response.status
          handles[response.status].call response
        else
          alarm = Model::Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, alarm)
        end
      end

      def find(params = {})
        response = @connection.get('customers/find', params)
        if handles.key? response.status
          handles[response.status].call response
        else
          customer = JSON.parse(response.body).map { |j| Model::Customer.new(j.deep_transform_keys(&:underscore)) }
          Response.new(response, customer)
        end
      end

      def get(id)
        response = @connection.get("customers/#{id}")
        if response.status == 404
          nil
        else
          customer = Model::Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, customer)
        end
      end

      def get!(id)
        response = @connection.get("customers/#{id}")
        raise InvisibleCollector::NotFound.from_json(response.body) if response.status == 404

        customer = Model::Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, customer)
      end

      def save(customer = {})
        response = execute_post('/customers', customer)
        customer = Model::Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, customer)
      end

      def update(customer = {})
        body = customer.is_a?(Model::Customer) ? customer.to_h : customer
        response = execute do |connection|
          connection.put do |req|
            req.url "/customers/#{body[:gid]}"
            req.headers['Content-Type'] = 'application/json'
            req.body = body.to_json
          end
        end
        customer = Model::Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, customer)
      end
    end
  end
end
