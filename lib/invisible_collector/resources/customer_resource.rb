module InvisibleCollector
  class CustomerResource

    include InvisibleCollector::DefaultHandlers

    def initialize(options = {})
      super(options)
      handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
    end

    def alarm(customer, params={})
      id = customer.is_a?(Customer) ? customer.gid : customer
      response = @connection.get("customers/#{id}/alarm", params)
      if response.status == 404
        nil
      else
        if handles.has_key? response.status
          handles[response.status].call response
        else
          Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        end
      end
    end

    def find(params={})
      response = @connection.get('customers/find', params)
      if handles.has_key? response.status
        handles[response.status].call response
      else
        JSON.parse(response.body).map { |json| Customer.new(json.deep_transform_keys(&:underscore)) }
      end
    end

    def get(id)
      response = @connection.get("customers/#{id}")
      if response.status == 404
        nil
      else
        Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def get!(id)
      response = @connection.get("customers/#{id}")
      if response.status == 404
        raise InvisibleCollector::NotFound.from_json(response.body)
      else
        Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def save(customer = {})
      response = execute_post('/customers', customer)
      Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end

    def update(customer = {})
      body = customer.is_a?(Customer) ? customer.to_h : customer
      response = execute do |connection|
        connection.put do |req|
          req.url "/customers/#{body[:gid]}"
          req.headers['Content-Type'] = 'application/json'
          req.body = body.to_json
        end
      end
      Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end
  end
end
