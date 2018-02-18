module InvoiceCapture
  class Unauthorized < RuntimeError

    def self.from_json(json)
      message = JSON.parse(json)
      code = message['code']
      message = message['message']
      new "#{code}: #{message}"
    end
  end
end
