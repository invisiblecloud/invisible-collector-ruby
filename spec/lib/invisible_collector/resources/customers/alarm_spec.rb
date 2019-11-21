require 'spec_helper'

describe InvisibleCollector::Resources::CustomerResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#alarm' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Customer already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("customer/#{key}")
        stub_do_api("/v1/customers/something/alarm").to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.alarm('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'returns null if not found' do
      fixture = api_fixture('customer/alarm')
      stub_do_api('/v1/customers/something/alarm').to_return(body: fixture, status: 404)
      response = resource.alarm('something')
      expect(response).to be_error

      alarm = response.content
      expect(alarm).to be_nil
    end

    it 'returns an alarm' do
      fixture = api_fixture('customer/alarm')
      parsed  = JSON.load(fixture)

      stub_do_api('/v1/customers/something/alarm').to_return(body: fixture)
      response = resource.alarm('something')
      expect(response).to be_success

      alarm = response.content
      expect(alarm).to be_kind_of(InvisibleCollector::Model::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
    end

    it 'includes created and updated dates' do
      fixture = api_fixture('customer/alarm')
      parsed  = JSON.load(fixture)

      stub_do_api('/v1/customers/something/alarm').to_return(body: fixture)
      response = resource.alarm('something')
      expect(response).to be_success

      alarm = response.content
      expect(alarm).to be_kind_of(InvisibleCollector::Model::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.created_at).to eq(parsed['createdAt'])
      expect(alarm.updated_at).to eq(parsed['updatedAt'])
      expect(alarm.created_at).to be_a(Time)
      expect(alarm.updated_at).to be_a(Time)
    end
  end
end
