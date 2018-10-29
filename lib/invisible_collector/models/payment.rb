module InvisibleCollector
  class Payment
    include InvisibleCollector::ModelAttributes

    attr_accessor :number
    attr_accessor :external_id

    def initialize(options = {})
      options = options.with_indifferent_access
      @number = options[:number]
      @external_id = options[:external_id]
    end
  end
end
