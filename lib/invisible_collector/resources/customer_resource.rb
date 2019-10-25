# frozen_string_literal: true

module InvisibleCollector
  module Resources
    class CustomerResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def alarm(customer, params = {})
        id = customer.is_a?(Model::Customer) ? customer.gid : customer
        response = @connection.get("customers/#{id}/alarm", params)
        if response.status == 404
          Response.new(response, nil)
        elsif handles.key? response.status
          handles[response.status].call response
        else
          alarm = Model::Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, alarm)
        end
      end

      #
      # Returns a list of all debts registered for the specified customer.
      # The customer attribute can be either a InvisibleCollector::Model::Customer instance or a customer id.
      #
      #  gid = 'customer id'
      #  c = InvisibleCollector::Model::Customer.new(gid: gid)
      #  client.customer.debts(c) #=> [InvisibleCollector::Model::Debt]
      #  client.customer.debts(gid) #=> [InvisibleCollector::Model::Debt]
      #
      def debts(customer, params = {})
        id = customer.is_a?(Model::Customer) ? customer.gid : customer
        response = @connection.get("customers/#{id}/debts", params)
        raise InvisibleCollector::NotFound.from_json(response.body) if response.status == 404

        if handles.key?(response.status)
          handles[response.status].call response
        else
          debts = JSON.parse(response.body).map { |j| Model::Debt.new(j.deep_transform_keys(&:underscore)) }
          Response.new(response, debts)
        end
      end

      def find(params = {})
        response = @connection.get('customers/find', params)
        if handles.key? response.status
          handles[response.status].call response
        else
          customer = JSON.parse(response.body).map { |j| Model::Customer.new(j.deep_transform_keys(&:underscore)) }
          Response.new(response, customer)
        end
      end

      def get(id)
        response = @connection.get("customers/#{id}")
        if response.status == 404
          nil
        else
          build_response(response)
        end
      end

      def get!(id)
        response = @connection.get("customers/#{id}")
        raise InvisibleCollector::NotFound.from_json(response.body) if response.status == 404

        build_response(response)
      end

      def save(customer = {})
        response = execute_post('/customers', customer)
        build_response(response)
      end

      def update(customer = {})
        body = customer.is_a?(Model::Customer) ? customer.to_h : customer
        response = execute do |connection|
          connection.put do |req|
            req.url "/customers/#{body[:gid]}"
            req.headers['Content-Type'] = 'application/json'
            req.body = body.to_json
          end
        end
        build_response(response)
      end

      private

      def build_response(response)
        customer = Model::Customer.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, customer)
      end
    end
  end
end
