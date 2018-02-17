module InvoiceCapture
  class CustomerResource

    include InvoiceCapture::DefaultHandlers

    def initialize(options = {})
      @connection = options[:connection]
      handle(400) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(409) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(422) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
    end

    def alarm(customer, params={})
      id = customer.is_a?(Customer) ? customer.gid : customer
      response = @connection.get("customers/#{id}/alarm", params)
      Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end

    def find(params={})
      response = @connection.get('customers/find', params)
      JSON.parse(response.body).map { |json| Customer.new(json.deep_transform_keys(&:underscore)) }
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
        raise InvoiceCapture::NotFound.from_json(response.body)
      else
        Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def save(customer = {})
      response = @connection.post do |req|
        req.url '/customers'
        req.headers['Content-Type'] = 'application/json'
        req.body = customer.to_json
      end
      if handles.has_key? response.status
        handles[response.status].call response
      else
        Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end
  end
end
