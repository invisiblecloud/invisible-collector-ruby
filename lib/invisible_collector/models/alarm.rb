# frozen_string_literal: true

module InvisibleCollector
  module Model
    class Alarm < AbstractModel
      attr_accessor :gid
      attr_accessor :status
      attr_accessor :created_at
      attr_accessor :updated_at

      def initialize(options = {})
        options = options.with_indifferent_access
        @gid = options[:gid]
        @status = options[:status]
        @created_at = Time.parse(options[:created_at]) if options[:created_at]
        @updated_at = Time.parse(options[:updated_at]) if options[:updated_at]
      end
    end
  end
end
