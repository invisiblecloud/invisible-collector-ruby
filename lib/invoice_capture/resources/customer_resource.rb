module InvoiceCapture
  class CustomerResource

    def initialize(options = {})
      @connection = options[:connection]
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
      if response.status == 422 || response.status == 400 || response.status == 409
        raise InvoiceCapture::InvalidRequest.from_json(response.body)
      else
        Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end
  end
end
