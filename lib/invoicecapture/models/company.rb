module InvoiceCapture
  class Company

    attr_accessor :name
    attr_accessor :vat_number
    attr_accessor :address
    attr_accessor :zip_code
    attr_accessor :city
    attr_accessor :country
    attr_accessor :gid
    attr_accessor :notifications_enabled

    def initialize(options={})
      options = options.with_indifferent_access
      @name = options['name']
      @vat_number = options['vatNumber']
      @address = options['address']
      @zip_code = options['zipCode']
      @city = options['city']
      @country = options['country']
      @gid = options['gid']
      @notifications_enabled = options['notificationsEnabled']
    end

  end
end
