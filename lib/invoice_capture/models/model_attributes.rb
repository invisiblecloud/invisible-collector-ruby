module InvoiceCapture
  module ModelAttributes

    def attribute(name)
      attr_accessor name
      (@@attributes ||= []) << name
    end

    def to_json
      Hash[ @@attributes.collect { |a| [ a.to_s.camelcase(:lower), send(a) ] } ].to_json
    end
  end
end
