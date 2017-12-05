module InvoiceCapture
  class DebtResource

    include InvoiceCapture::DefaultHandlers

    def initialize(options = {})
      @connection = options[:connection]
      handle(400) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(404) { |response| raise InvoiceCapture::NotFound.from_json(response.body) }
      handle(409) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(422) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
    end

    def cancel(debt = {})
      id = debt.kind_of?(InvoiceCapture::Debt) ? debt.external_id : debt
      response = @connection.put("debts/#{id}/cancel")
      if handles.has_key? response.status
        handles[response.status].call response
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
        req.url 'debts'
        req.headers['Content-Type'] = 'application/json'
        req.body = debt.to_json
      end
      if handles.has_key? response.status
        handles[response.status].call response
      else
        Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

  end

end
