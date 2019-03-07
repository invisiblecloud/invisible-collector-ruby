require 'spec_helper'

describe InvisibleCollector::Resources::VmsResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns the vms info' do
      fixture = voice_fixture('vms/get')
      parsed  = JSON.load(fixture)

      stub_do_voice('/vms/id').to_return(body: fixture)
      response = resource.get 'id'
      expect(response).to be_success

      vms = response.content
      expect(vms).to be_kind_of(InvisibleCollector::Model::Vms)

      expect(vms.id).to eq(parsed['id'])
      expect(vms.status).to eq(parsed['status'])
      expect(vms.events.size).to eq(parsed['events'].size)
      expect(vms.events.first['description']).to eq(parsed['events'].first['description'])
      expect(vms.events.first['event']).to eq(parsed['events'].first['event'])
      expect(vms.events.first['created_at']).to eq(parsed['events'].first['createdAt'])
    end
  end
end
