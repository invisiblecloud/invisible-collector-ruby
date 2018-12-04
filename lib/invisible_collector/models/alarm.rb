module InvisibleCollector
  class Alarm < Model
    attr_accessor :gid
    attr_accessor :status
    attr_accessor :created_at
    attr_accessor :updated_at

    def initialize(options = {})
      options = options.with_indifferent_access
      @gid = options[:gid]
      @status = options[:status]
      @created_at = options[:createdAt]
      @updated_at = options[:updatedAt]
    end
  end
end
