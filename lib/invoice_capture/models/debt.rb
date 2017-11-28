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

    def initialize(options={})
      options = options.with_indifferent_access
      @number = options[:number]
      @external_id = options[:externalId]
      @type = options[:type]
      @status = options[:status]
      @date = options[:date]
      @due_date = options[:dueDate]
      @customer = options[:customer]
      @items = options[:items]
      @net_total = options[:netTotal]
      @tax = options[:tax]
      @gross_total = options[:grossTotal]
      @currency = options[:currency]
    end
  end
end
