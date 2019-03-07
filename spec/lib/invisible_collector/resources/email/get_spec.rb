require 'spec_helper'

describe InvisibleCollector::Resources::EmailResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns the email info' do
      fixture = voice_fixture('email/get')
      parsed  = JSON.load(fixture)

      stub_do_voice('/email/id').to_return(body: fixture)
      response = resource.get('id')
      expect(response).to be_success

      email = response.content
      expect(email).to be_kind_of(InvisibleCollector::Model::Email)

      expect(email.id).to eq(parsed['gid'])
      expect(email.destination).to eq(parsed['destination'])
      expect(email.status).to eq(parsed['status'])
      expect(email.events.size).to eq(parsed['events'].size)
      expect(email.events.first['description']).to eq(parsed['events'].first['description'])
      expect(email.events.first['event']).to eq(parsed['events'].first['event'])
      expect(email.events.first['created_at']).to eq(parsed['events'].first['createdAt'])
    end
  end
end
