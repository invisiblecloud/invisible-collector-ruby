# frozen_string_literal: true

module InvisibleCollector
  module Model
    class Customer < AbstractModel
      attr_accessor :name
      attr_accessor :vat_number
      attr_accessor :gid
      attr_accessor :external_id
      attr_accessor :email
      attr_accessor :phone
      attr_accessor :mobile
      attr_accessor :address
      attr_accessor :zip_code
      attr_accessor :city
      attr_accessor :country

      def initialize(options = {})
        options = options.with_indifferent_access
        @name = options[:name]
        @vat_number = options[:vat_number]
        @gid = options[:gid]
        @external_id = options[:external_id]
        @email = options[:email]
        @phone = options[:phone]
        @mobile = options[:mobile]
        @address = options[:address]
        @zip_code = options[:zip_code]
        @city = options[:city]
        @country = options[:country]
      end
    end
  end
end
