# frozen_string_literal: true

module InvisibleCollector
  module Resources
    class DebtResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(404) { |response| raise InvisibleCollector::NotFound.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def cancel(debt = {})
        id = get_id(debt)
        response = execute do |connection|
          connection.put("debts/#{id}/cancel")
        end
        build_response(response)
      end

      def find(params = {})
        response = execute_get('debts/find', params)
        debts = JSON.parse(response.body).map { |json| Model::Debt.new(json.deep_transform_keys(&:underscore)) }
        Response.new(response, debts)
      end

      def get(id, attrs = {})
        response = @connection.get("debts/#{id}", attrs)
        if response.status == 404
          nil
        else
          build_response(response)
        end
      end

      def save(debt)
        response = execute_post('debts', debt)
        build_response(response)
      end

      def save_debit(debt, debit)
        id = debt.is_a?(Model::Debt) ? debt.id : debt
        response = execute_post("debts/#{id}/debits", debit)
        debit = Model::Debit.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, debit)
      end

      def save_credit(debt, credit)
        id = debt.is_a?(Model::Debt) ? debt.id : debt
        response = execute_post("debts/#{id}/credits", credit)
        credit = Model::Credit.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, credit)
      end

      def suspend(debt = {})
        id = get_id(debt)
        response = execute do |connection|
          connection.put("debts/#{id}/suspend")
        end
        build_response(response)
      end

      def unsuspend(debt = {})
        id = get_id(debt)
        response = execute do |connection|
          connection.put("debts/#{id}/unsuspend")
        end
        build_response(response)
      end

      private

      def build_response(response)
        debt = Model::Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, debt)
      end

      def get_id(debt)
        if debt.is_a?(InvisibleCollector::Model::Debt)
          debt.id
        elsif debt.is_a?(Hash)
          debt[:id]
        else
          debt
        end
      end
    end
  end
end
