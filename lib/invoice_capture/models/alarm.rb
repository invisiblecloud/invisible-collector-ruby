module InvoiceCapture

  class Alarm
    extend InvoiceCapture::ModelAttributes

    attribute :gid
    attribute :status
    attribute :createdAt
    attribute :updatedAt

    def initialize(options={})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @status = options[:status]
      @createdAt = options[:createdAt]
      @updatedAt = options[:updatedAt]
    end
  end
end
