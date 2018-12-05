module InvisibleCollector
  module Resources
    class AlarmResource
      include InvisibleCollector::DefaultHandlers

      def initialize(options = {})
        super(options)
        handle(400) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(409) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
        handle(422) { |response| raise InvisibleCollector::InvalidRequest.from_json(response.body) }
      end

      def close(alarm)
        gid = alarm.is_a?(Model::Alarm) ? alarm.gid : alarm
        response = execute do |connection|
          connection.put("alarms/#{gid}/close", nil)
        end
        alarm = Model::Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, alarm)
      end

      def save_event(alarm, event)
        gid = alarm.is_a?(Model::Alarm) ? alarm.gid : alarm
        response = execute_post("alarms/#{gid}/events", event)
        alarm = Model::AlarmEvent.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
        Response.new(response, alarm)
      end

      def get(gid)
        response = @connection.get("alarms/#{gid}")
        if response.status == 404
          Response.new(response, nil)
        elsif handles.key? response.status
          handles[response.status].call response
        else
          alarm = Model::Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, alarm)
        end
      end

      def get!(gid)
        response = @connection.get("alarms/#{gid}")
        raise InvisibleCollector::NotFound.from_json(response.body) if response.status == 404

        if handles.key? response.status
          handles[response.status].call response
        else
          alarm = Model::Alarm.new(JSON.parse(response.body).deep_transform_keys(&:underscore))
          Response.new(response, alarm)
        end
      end
    end
  end
end
