require 'spec_helper'

describe InvisibleCollector::Resources::AlarmResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#close' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Random conflict error' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
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
      response = resource.close(parsed['gid'])
      expect(response).to be_success

      alarm = response.content
      expect(alarm).to be_kind_of(InvisibleCollector::Model::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.created_at).to eq(parsed['createdAt'])
      expect(alarm.updated_at).to eq(parsed['updatedAt'])
    end

    it 'closes an alarm using the actual alarm' do
      fixture = api_fixture('alarm/close')
      parsed  = JSON.load(fixture)
      alarm = InvisibleCollector::Model::Alarm.new gid: parsed['gid']
      stub_do_api("/alarms/#{parsed['gid']}/close", :put).with(body: nil).to_return(body: fixture)
      response = resource.close(alarm)
      expect(response).to be_success

      alarm = response.content
      expect(alarm).to be_kind_of(InvisibleCollector::Model::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.created_at).to eq(parsed['createdAt'])
      expect(alarm.updated_at).to eq(parsed['updatedAt'])
    end
  end
end
