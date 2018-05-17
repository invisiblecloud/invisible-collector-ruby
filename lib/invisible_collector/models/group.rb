module InvisibleCollector

  class Group
    include InvisibleCollector::ModelAttributes

    attr_accessor :id
    attr_accessor :name

    def initialize(options = {})
      options = options.with_indifferent_access
      @id = options[:id]
      @name = options[:name]
    end
  end
end
