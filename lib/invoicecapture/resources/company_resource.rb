module InvoiceCapture
  class CompanyResource

    def initialize(options = {})
      @connection = options[:connection]
    end

    def get
      Company.new(JSON.parse(@connection.get('').body))
    end

    def update
    end

    def enable_notifications
    end

    def disable_notifications
    end
  end
end
