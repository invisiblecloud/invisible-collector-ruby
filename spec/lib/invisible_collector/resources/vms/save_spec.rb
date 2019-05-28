require 'spec_helper'

describe InvisibleCollector::Resources::VmsResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save' do

    { invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      forbidden: { code: 403, exception: InvisibleCollector::Forbidden,
                      message: 'Not enough VMS credits. Only has 0 credits to send 1 VMS'},
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Vms not found' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest,
                       message: 'Unprocessable request' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = voice_fixture("vms/#{key}")
        stub_do_voice('/vms', :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.save params
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'uses a vms hash' do
      fixture = voice_fixture('vms/save')
      parsed  = JSON.load(fixture).first

      attrs = { origin: 'sdfsad', destinations: ['sfsdfsad'], message: 'SD', notifyUrl: 'fsdfas' }
      stub_do_voice('/vms', :post).with(body: attrs.to_json).to_return(body: fixture)
      response = resource.save attrs
      expect(response).to be_success

      vms = response.content.first
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
