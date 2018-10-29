require 'spec_helper'

describe InvisibleCollector::AlarmResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save_event' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("alarm/#{key}")
        stub_do_api("/alarms/something/events", :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.save_event 'something', params
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    [
      { gid: SecureRandom.uuid, origin: 'potatoes@farm.com', destination: 'onions@farm.com' },
      { gid: SecureRandom.uuid, origin: 'potatoes@farm.com', destination: 'onions@farm.com', debts: ["FT 1", "FT 2"] }
    ].each do |attrs|

      it 'using an event object' do
        fixture = api_fixture('alarm/save_event')
        parsed  = JSON.load(fixture)

        event = InvisibleCollector::AlarmEvent.new(attrs)
        stub_do_api("/alarms/something/events", :post).with(body: event.to_json).to_return(body: fixture, status: 201)
        event = resource.save_event "something", event

        expect(event).to be_kind_of(InvisibleCollector::AlarmEvent)

        expect(event.gid).to eq(parsed['gid'])
        expect(event.origin).to eq(parsed['origin'])
        expect(event.destination).to eq(parsed['destination'])
        expect(event.message).to eq(parsed['message'])
        expect(event.message_type).to eq(parsed['messageType'])
      end

      it 'using an event hash' do
        fixture = api_fixture('alarm/save_event')
        parsed  = JSON.load(fixture)

        stub_do_api('/alarms/something/events', :post).with(body: attrs.to_json).to_return(body: fixture, status: 201)
        event = resource.save_event 'something', attrs

        expect(event).to be_kind_of(InvisibleCollector::AlarmEvent)

        expect(event.gid).to eq(parsed['gid'])
        expect(event.origin).to eq(parsed['origin'])
        expect(event.destination).to eq(parsed['destination'])
        expect(event.message).to eq(parsed['message'])
        expect(event.message_type).to eq(parsed['messageType'])
      end
    end
  end
end
