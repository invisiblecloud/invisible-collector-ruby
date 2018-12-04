module InvisibleCollector
  module Model
    class Company < AbstractModel
      attr_accessor :name
      attr_accessor :vat_number
      attr_accessor :address
      attr_accessor :zip_code
      attr_accessor :city
      attr_accessor :country
      attr_accessor :gid
      attr_accessor :notifications_enabled

      def initialize(options = {})
        options = options.with_indifferent_access
        @name = options['name']
        @vat_number = options['vat_number']
        @address = options['address']
        @zip_code = options['zip_code']
        @city = options['city']
        @country = options['country']
        @gid = options['gid']
        @notifications_enabled = options['notifications_enabled']
      end
    end
  end
end
