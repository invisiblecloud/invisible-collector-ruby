module InvoiceCapture
  module DefaultHandlers
    def handles
      @handles ||= {}
    end

    def handle(code, &block)
      handles[code] = block
    end
  end
end
