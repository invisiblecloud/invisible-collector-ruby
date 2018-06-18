module InvisibleCollector

  class Alarm
    include InvisibleCollector::ModelAttributes

    attr_accessor :gid
    attr_accessor :status
    attr_accessor :createdAt
    attr_accessor :updatedAt

    def initialize(options = {})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @status = options[:status]
      @createdAt = options[:createdAt]
      @updatedAt = options[:updatedAt]
    end
  end
end
