require 'spec_helper'

describe InvisibleCollector::Resources::SmsResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns the sms info' do
      fixture = voice_fixture('sms/get')
      parsed  = JSON.load(fixture)

      stub_do_voice('/sms/id').to_return(body: fixture)
      response = resource.get 'id'
      expect(response).to be_success

      sms = response.content
      expect(sms).to be_kind_of(InvisibleCollector::Model::Sms)

      expect(sms.id).to eq(parsed['id'])
      expect(sms.destination).to eq(parsed['destination'])
      expect(sms.status).to eq(parsed['status'])
      expect(sms.events.size).to eq(parsed['events'].size)
      expect(sms.events.first['description']).to eq(parsed['events'].first['description'])
      expect(sms.events.first['event']).to eq(parsed['events'].first['event'])
      expect(sms.events.first['created_at']).to eq(parsed['events'].first['createdAt'])
    end
  end
end
