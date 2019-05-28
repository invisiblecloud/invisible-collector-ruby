# frozen_string_literal: true.

module InvisibleCollector
  module Resources
    class GroupResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(404) { |response| raise InvisibleCollector::NotFound.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def add_customer(group, customer)
        group_id = group.is_a?(Model::Group) ? group.id : group
        customer_id = customer.is_a?(Model::Customer) ? customer.gid : customer
        response = execute_post("groups/#{group_id}/customers/#{customer_id}", {})
        group = Model::Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, group)
      end

      def all(params = {})
        response = execute_get('groups', params)
        groups = JSON.parse(response.body).map { |json| Model::Group.new(json.deep_transform_keys(&:underscore)) }
        Response.new(response, groups)
      end

      def get!(gid)
        response = @connection.get("groups/#{gid}")
        if handles.key? response.status
          handles[response.status].call response
        else
          group = Model::Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, group)
        end
      end

      def save(group)
        response = execute_post('groups', group)
        group = Model::Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, group)
      end
    end
  end
end
