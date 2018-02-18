require 'spec_helper'

describe InvoiceCapture::AlarmResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save_event' do

    {
      invalid: { code: 400, exception: InvoiceCapture::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvoiceCapture::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvoiceCapture::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvoiceCapture::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("alarm/#{key}")
        stub_do_api("/alarms/something/events", :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.save_event "something", params
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'uses an alarm event object' do
      fixture = api_fixture('alarm/save_event')
      parsed  = JSON.load(fixture)

      attrs = { gid: SecureRandom.uuid, origin: 'potatoes@farm.com', destination: 'onions@farm.com' }
      event = InvoiceCapture::AlarmEvent.new(attrs)
      stub_do_api("/alarms/something/events", :post).with(body: event.to_json).to_return(body: fixture, status: 201)
      event = resource.save_event "something", event

      expect(event).to be_kind_of(InvoiceCapture::AlarmEvent)

      expect(event.gid).to eq(parsed['gid'])
      expect(event.origin).to eq(parsed['origin'])
      expect(event.destination).to eq(parsed['destination'])
    end

    it 'uses an alarm event hash' do
      fixture = api_fixture('alarm/save_event')
      parsed  = JSON.load(fixture)

      attrs = { gid: SecureRandom.uuid, origin: 'potatoes@farm.com', destination: 'onions@farm.com' }
      stub_do_api("/alarms/something/events", :post).with(body: attrs.to_json).to_return(body: fixture, status: 201)
      event = resource.save_event "something", attrs

      expect(event).to be_kind_of(InvoiceCapture::AlarmEvent)

      expect(event.gid).to eq(parsed['gid'])
      expect(event.origin).to eq(parsed['origin'])
      expect(event.destination).to eq(parsed['destination'])
    end

  end

  describe '#get' do

    it 'returns null if not found' do
      fixture = api_fixture('alarm/not_found')
      stub_do_api("/alarms/something").to_return(body: fixture, status: 404)
      alarm = resource.get('something')

      expect(alarm).to be_nil
    end

    it 'returns the alarm info using gid' do
      fixture = api_fixture('alarm/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/alarms/#{parsed['gid']}").to_return(body: fixture)
      alarm = resource.get(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

  describe '#get!' do

    {
      invalid: { code: 400, exception: InvoiceCapture::InvalidRequest, message: 'Invalid JSON' },
      not_found: { code: 404, exception: InvoiceCapture::NotFound, message: 'Alarm not found' },
      unauthorized: { code: 401, exception: InvoiceCapture::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvoiceCapture::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvoiceCapture::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("alarm/#{key}")
        stub_do_api("/alarms/something").to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.get!('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'returns the customer info using gid' do
      fixture = api_fixture('alarm/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/alarms/#{parsed['gid']}").to_return(body: fixture)
      alarm = resource.get!(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

  describe '#close' do

    {
      invalid: { code: 400, exception: InvoiceCapture::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvoiceCapture::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvoiceCapture::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvoiceCapture::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("alarm/#{key}")
        stub_do_api("/alarms/something/close", :put).with(body: nil).to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.close('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'closes an alarm using gid' do
      fixture = api_fixture('alarm/close')
      parsed  = JSON.load(fixture)
      stub_do_api("/alarms/#{parsed['gid']}/close", :put).with(body: nil).to_return(body: fixture)
      alarm = resource.close(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

    it 'closes an alarm using the actual alarm' do
      fixture = api_fixture('alarm/close')
      parsed  = JSON.load(fixture)
      alarm = InvoiceCapture::Alarm.new gid: parsed['gid']
      stub_do_api("/alarms/#{parsed['gid']}/close", :put).with(body: nil).to_return(body: fixture)
      alarm = resource.close(alarm)

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

end