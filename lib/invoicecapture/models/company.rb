module InvoiceCapture
  class Company

    attr_accessor :name

    def initialize(options={})
      @name = options['name']
    end

  end
end
