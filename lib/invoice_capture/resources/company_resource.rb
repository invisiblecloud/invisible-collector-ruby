module InvoiceCapture
  class CompanyResource

    def initialize(options = {})
      @connection = options[:connection]
    end

    def get
      Company.new(JSON.parse(@connection.get('companies').body))
    end

    def update(company)
      Company.new(JSON.parse(@connection.put('companies', company).body))
    end

    def enable_notifications
      Company.new(JSON.parse(@connection.put('/companies/enableNotifications').body))
    end

    def disable_notifications
      Company.new(JSON.parse(@connection.put('/companies/disableNotifications').body))
    end
  end
end
