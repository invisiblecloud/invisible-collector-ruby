# frozen_string_literal: true

module InvisibleCollector
  module Model
    class EmailList < AbstractModel
      attr_accessor :records
      attr_accessor :total_records

      def initialize(options = {})
        options = options.with_indifferent_access
        @records = options[:records].map { |r| Email.new(r) }
        @total_records = options[:total_records]
      end
    end
  end
end
