module InvoiceCapture

  class Debt
    extend InvoiceCapture::ModelAttributes

    attribute :number
    attribute :external_id
    attribute :type
    attribute :status
    attribute :date
    attribute :due_date
    attribute :customer
    attribute :items
    attribute :net_total
    attribute :tax
    attribute :gross_total
    attribute :currency
    attribute :attributes

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
