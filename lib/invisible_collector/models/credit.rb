module InvisibleCollector
  class Credit < Model
    attr_accessor :number
    attr_accessor :description
    attr_accessor :date
    attr_accessor :gross_total

    def initialize(options = {})
      options = options.with_indifferent_access
      @number = options[:number]
      @description = options[:description]
      @date = options[:date]
      @gross_total = options[:gross_total]
    end
  end
end
