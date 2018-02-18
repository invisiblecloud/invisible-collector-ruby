module InvoiceCapture
  class AlarmResource

    include InvoiceCapture::DefaultHandlers

    def initialize(options = {})
      @connection = options[:connection]
      handle(400) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(409) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(422) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
    end

    def close(alarm)
      gid = alarm.is_a?(Alarm) ? alarm.gid : alarm
      Alarm.new(JSON.parse(@connection.put("alarms/#{gid}/close", nil).body).deep_transform_keys(&:underscore))
    end

    def save_event(alarm, event)
      gid = alarm.is_a?(Alarm) ? alarm.gid : alarm
      response = @connection.post do |req|
        req.url "alarms/#{gid}/events"
        req.headers['Content-Type'] = 'application/json'
        req.body = event.to_json
      end
      if handles.has_key? response.status
        handles[response.status].call response
      else
        AlarmEvent.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def get(gid)
      response = @connection.get("alarms/#{gid}")
      if response.status == 404
        nil
      else
        Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

    def get!(gid)
      response = @connection.get("alarms/#{gid}")
      if response.status == 404
        raise InvoiceCapture::NotFound.from_json(response.body)
      else
        Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
      end
    end

  end
end
