module InvisibleCollector
  module Model
    class Email < AbstractModel
      attr_accessor :id
      attr_accessor :destination
      attr_accessor :status
      attr_accessor :events

      def initialize(options = {})
        options = options.with_indifferent_access
        @id = options[:gid]
        @destination = options[:destination]
        @status = options[:status]
        @events = options[:events]
      end
    end
  end
end
