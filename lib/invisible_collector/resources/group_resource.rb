module InvisibleCollector
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
      group_id = group.is_a?(Group) ? group.id : group
      customer_id = customer.is_a?(Customer) ? customer.gid : customer
      response = execute_post("groups/#{group_id}/customers/#{customer_id}", {})
      Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end

    def all(params = {})
      response = execute_get('groups', params)
      JSON.parse(response.body).map { |json| Group.new(json.deep_transform_keys(&:underscore)) }
    end

    def get!(gid)
      response = @connection.get("groups/#{gid}")
      if handles.key? response.status
        handles[response.status].call response
      else
        Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def save(group)
      response = execute_post('groups', group)
      Group.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end
  end
end
