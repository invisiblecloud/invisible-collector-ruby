module InvisibleCollector

  class AlarmEvent
    include InvisibleCollector::ModelAttributes

    attr_accessor :gid
    attr_accessor :origin
    attr_accessor :destination
    attr_accessor :debts

    def initialize(options = {})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @origin = options[:origin]
      @destination = options[:destination]
      @debts = options[:debts]
    end
  end
end
