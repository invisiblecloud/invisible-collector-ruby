module InvoiceCapture

  class Company
    extend InvoiceCapture::ModelAttributes

    attribute :name
    attribute :vat_number
    attribute :address
    attribute :zip_code
    attribute :city
    attribute :country
    attribute :gid
    attribute :notifications_enabled

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
