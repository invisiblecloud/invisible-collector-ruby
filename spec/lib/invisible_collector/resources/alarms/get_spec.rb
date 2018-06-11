require 'spec_helper'

describe InvisibleCollector::AlarmResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("alarm/#{key}")
        stub_do_api("/alarms/something").to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.get('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

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

      expect(alarm).to be_kind_of(InvisibleCollector::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

  describe '#get!' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Alarm not found' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
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

      expect(alarm).to be_kind_of(InvisibleCollector::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end
  end
end
