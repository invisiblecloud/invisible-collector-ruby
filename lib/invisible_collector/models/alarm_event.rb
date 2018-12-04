module InvisibleCollector
  class AlarmEvent < Model
    attr_accessor :gid
    attr_accessor :origin
    attr_accessor :destination
    attr_accessor :message
    attr_accessor :message_type
    attr_accessor :debts

    def initialize(options = {})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @origin = options[:origin]
      @destination = options[:destination]
      @message = options[:message]
      @message_type = options[:message_type]
      @debts = options[:debts]
    end
  end
end
