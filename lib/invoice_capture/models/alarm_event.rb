module InvoiceCapture

  class AlarmEvent
    extend InvoiceCapture::ModelAttributes

    attribute :gid
    attribute :origin
    attribute :destination

    def initialize(options={})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @origin = options[:origin]
      @destination = options[:destination]
    end
  end
end
