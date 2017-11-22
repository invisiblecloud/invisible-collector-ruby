module InvoiceCapture
  class Customer

    attr_accessor :name
    attr_accessor :gid
    attr_accessor :address

    def initialize(options={})
      @name = options['name']
      @gid = options['gid']
      @address = options['address']
    end

  end
end
