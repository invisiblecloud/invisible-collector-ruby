module InvisibleCollector
  class Payment < Model
    attr_accessor :number
    attr_accessor :external_id

    def initialize(options = {})
      options = options.with_indifferent_access
      @number = options[:number]
      @external_id = options[:external_id]
    end
  end
end
