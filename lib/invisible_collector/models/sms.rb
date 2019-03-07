module InvisibleCollector
  module Model
    class Sms < AbstractModel
      attr_accessor :id
      attr_accessor :destination
      attr_accessor :status
      attr_accessor :events

      def initialize(options = {})
        options = options.with_indifferent_access
        @id = options[:id]
        @destination = options[:destination]
        @status = options[:status]
        @events = options[:events]
      end
    end
  end
end
