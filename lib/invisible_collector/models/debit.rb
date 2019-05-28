# frozen_string_literal: true

module InvisibleCollector
  module Model
    class Debit < AbstractModel
      attr_accessor :number
      attr_accessor :date
      attr_accessor :gross_total

      def initialize(options = {})
        options = options.with_indifferent_access
        @number = options[:number]
        @date = options[:date]
        @gross_total = options[:gross_total]
      end
    end
  end
end
