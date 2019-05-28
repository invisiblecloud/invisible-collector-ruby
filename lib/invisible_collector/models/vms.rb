# frozen_string_literal: true

module InvisibleCollector
  module Model
    class Vms < AbstractModel
      attr_accessor :id
      attr_accessor :status
      attr_accessor :events

      def initialize(options = {})
        options = options.with_indifferent_access
        @id = options[:id]
        @status = options[:status]
        @events = options[:events]
      end
    end
  end
end
