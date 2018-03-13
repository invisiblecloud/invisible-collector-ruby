module InvoiceCapture

  class Debt
    include InvoiceCapture::ModelAttributes

    attr_accessor :number
    attr_accessor :external_id
    attr_accessor :type
    attr_accessor :status
    attr_accessor :date
    attr_accessor :due_date
    attr_accessor :customer
    attr_accessor :items
    attr_accessor :net_total
    attr_accessor :tax
    attr_accessor :gross_total
    attr_accessor :currency
    attr_accessor :attributes

    def initialize(options={})
      options = options.with_indifferent_access
      @number = options[:number]
      @external_id = options[:external_id]
      @type = options[:type]
      @status = options[:status]
      @date = options[:date]
      @due_date = options[:due_date]
      @customer = options[:customer]
      @items = options[:items]
      @attributes = options[:attributes]
      @net_total = options[:net_total]
      @tax = options[:tax]
      @gross_total = options[:gross_total]
      @currency = options[:currency]
    end
  end
end
