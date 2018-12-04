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
        id = debt.is_a?(InvisibleCollector::Model::Debt) ? debt.external_id : debt
        response = execute do |connection|
          connection.put("debts/#{id}/cancel")
        end
        Model::Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end

      def find(params = {})
        response = execute_get('debts/find', params)
        JSON.parse(response.body).map { |json| Model::Debt.new(json.deep_transform_keys(&:underscore)) }
      end

      def get(id, attrs = {})
        response = @connection.get("debts/#{id}", attrs)
        if response.status == 404
          nil
        else
          Model::Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        end
      end

      def save(debt)
        response = execute_post('debts', debt)
        Model::Debt.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end

      def save_debit(debt, debit)
        id = debt.is_a?(Model::Debt) ? debt.id : debt
        response = execute_post("debts/#{id}/debits", debit)
        Model::Debit.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end

      def save_credit(debt, credit)
        id = debt.is_a?(Model::Debt) ? debt.id : debt
        response = execute_post("debts/#{id}/credits", credit)
        Model::Credit.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end
  end
end
