module InvoiceCapture

  class Customer
    extend InvoiceCapture::ModelAttributes

    attribute :name
    attribute :vat_number
    attribute :gid
    attribute :phone
    attribute :address
    attribute :zip_code
    attribute :city
    attribute :country

    def initialize(options={})
      options = options.with_indifferent_access
      @name = options[:name]
      @vat_number = options[:vatNumber]
      @gid = options[:gid]
      @phone = options[:phone]
      @address = options[:address]
      @zip_code = options[:zipCode]
      @city = options[:city]
      @country = options[:country]
    end
  end
end
