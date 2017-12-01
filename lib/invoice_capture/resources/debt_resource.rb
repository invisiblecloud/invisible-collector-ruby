module InvoiceCapture
  class DebtResource

    def initialize(options = {})
      @connection = options[:connection]
    end

    def cancel(debt = {})
      id = debt.kind_of?(InvoiceCapture::Debt) ? debt.external_id : debt
      response = @connection.put("debts/#{id}/cancel")
      if response.status == 404
        raise InvoiceCapture::NotFound.from_json(response.body)
      else
        Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def find(params={})
      response = @connection.get('debts/find', params)
      JSON.parse(response.body).map { |json| Debt.new(json.deep_transform_keys(&:underscore)) }
    end

    def get(id)
      response = @connection.get("debts/#{id}")
      if response.status == 404
        nil
      else
        Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def save(debt)
      response = @connection.post do |req|
        req.url '/debts'
        req.headers['Content-Type'] = 'application/json'
        req.body = debt.to_json
      end
      if response.status == 422 || response.status == 400 || response.status == 409
        raise InvoiceCapture::InvalidRequest.from_json(response.body)
      else
        Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end
  end
end
