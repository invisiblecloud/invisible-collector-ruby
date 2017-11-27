require 'json'

module InvoiceCapture
  class CustomerResource

    def initialize(options = {})
      @connection = options[:connection]
    end

    def find(params={})
      response = @connection.get("customers/find?#{URI.encode_www_form(params)}")
      JSON.parse(response.body).map { |json| Customer.new(json) }
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
