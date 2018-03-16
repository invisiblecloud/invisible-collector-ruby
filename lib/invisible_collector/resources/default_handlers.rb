module InvisibleCollector
  module DefaultHandlers

    def initialize(options = {})
      @connection = options[:connection]
      handle(401) { |response| raise InvisibleCollector::Unauthorized.from_json(response.body) }
    end

    def execute
      response = yield(@connection)
      if handles.has_key? response.status
        handles[response.status].call response
      end
      response
    end

    def execute_get(endpoint, params)
      execute do |connection|
        connection.get(endpoint, params)
      end
    end

    def execute_post(endpoint, body)
      execute do |connection|
        connection.post do |req|
          req.url endpoint
          req.headers['Content-Type'] = 'application/json'
          req.body = (body.is_a?(String) ? body : body.to_json)
        end
      end
    end

    def handles
      @handles ||= {}
    end

    def handle(code, &block)
      handles[code] = block
    end
  end
end
