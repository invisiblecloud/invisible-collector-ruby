module InvoiceCapture
  module DefaultHandlers

    def initialize(options = {})
      @connection = options[:connection]
      handle(401) { |response| raise InvoiceCapture::Unauthorized.from_json(response.body) }
    end

    def execute
      response = yield(@connection)
      if handles.has_key? response.status
        handles[response.status].call response
      end
      response
    end

    def handles
      @handles ||= {}
    end

    def handle(code, &block)
      handles[code] = block
    end
  end
end
