module InvoiceCapture
  class Customer

    attr_accessor :name
    attr_accessor :gid
    attr_accessor :address
    attr_accessor :city
    attr_accessor :country

    def initialize(options={})
      @name = options['name']
      @gid = options['gid']
      @address = options['address']
      @city = options['city']
      @country = options['country']
    end

  end
end
