require 'json'

module InvoiceCapture
  class CustomerResource

    def initialize(options = {})
      @connection = options[:connection]
    end

    def get(id)
      response = @connection.get("customers/#{id}")
      if response.status == 404
        nil
      else
        Customer.new(JSON.parse(response.body))
      end
    end

    def get!(id)
      response = @connection.get("customers/#{id}")
      if response.status == 404
        message = JSON.parse(response.body)
        code = message['code']
        message = message['message']
        error = InvoiceCapture::NotFound.new "#{code}: #{message}"
        raise error
      else
        Customer.new(JSON.parse(response.body))
      end
    end

  end
end
