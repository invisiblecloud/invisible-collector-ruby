module InvoiceCapture
  class Customer

    attr_accessor :name
    attr_accessor :vat_number
    attr_accessor :gid
    attr_accessor :phone
    attr_accessor :address
    attr_accessor :city
    attr_accessor :country

    def initialize(options={})
      options = options.with_indifferent_access
      @name = options[:name]
      @vat_number = options[:vatNumber]
      @gid = options[:gid]
      @phone = options[:phone]
      @address = options[:address]
      @city = options[:city]
      @country = options[:country]
    end

    def to_json
      { name: @name, vatNumber: @vat_number, phone: @phone, address: @address, city: @city, country: @country }.to_json
    end

  end
end
