module InvoiceCapture
  class AlarmResource

    include InvoiceCapture::DefaultHandlers

    def initialize(options = {})
      super(options)
      handle(400) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(409) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
      handle(422) { |response| raise InvoiceCapture::InvalidRequest.from_json(response.body) }
    end

    def close(alarm)
      gid = alarm.is_a?(Alarm) ? alarm.gid : alarm
      response = execute do |connection|
        connection.put("alarms/#{gid}/close", nil)
      end
      Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end

    def save_event(alarm, event)
      gid = alarm.is_a?(Alarm) ? alarm.gid : alarm
      response = execute_post("alarms/#{gid}/events", event)
      AlarmEvent.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
    end

    def get(gid)
      response = @connection.get("alarms/#{gid}")
      if response.status == 404
        nil
      else
        if handles.has_key? response.status
          handles[response.status].call response
        else
          Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        end
      end
    end

    def get!(gid)
      response = @connection.get("alarms/#{gid}")
      if response.status == 404
        raise InvoiceCapture::NotFound.from_json(response.body)
      else
        if handles.has_key? response.status
          handles[response.status].call response
        else
          Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        end
      end
    end

  end
end
