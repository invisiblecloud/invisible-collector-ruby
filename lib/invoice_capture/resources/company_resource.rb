module InvoiceCapture
  class CompanyResource
    
    include InvoiceCapture::DefaultHandlers

    def initialize(options = {})
      super(options)
    end

    def get
      Company.new(JSON.parse(@connection.get('companies').body).deep_transform_keys(&:underscore))
    end

    def update(company)
      Company.new(JSON.parse(@connection.put('companies', company).body).deep_transform_keys(&:underscore))
    end

    def enable_notifications
      Company.new(JSON.parse(@connection.put('/companies/enableNotifications').body).deep_transform_keys(&:underscore))
    end

    def disable_notifications
      Company.new(JSON.parse(@connection.put('/companies/disableNotifications').body).deep_transform_keys(&:underscore))
    end
  end
end
