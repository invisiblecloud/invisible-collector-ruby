require 'spec_helper'

describe InvisibleCollector::Resources::SmsResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save' do

    { invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      forbidden: { code: 403, exception: InvisibleCollector::Forbidden,
                      message: 'Not enough SMS credits. Only has 0 credits to send 1 SMS'},
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Sms not found' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest,
                       message: 'Unprocessable request' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = voice_fixture("sms/#{key}")
        stub_do_voice('/sms', :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.save params
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'uses a sms hash' do
      fixture = voice_fixture('sms/save')
      parsed  = JSON.load(fixture).first

      attrs = { origin: 'sdfsad', destinations: ['sfsdfsad'], message: 'SD', notifyUrl: 'fsdfas' }
      stub_do_voice('/sms', :post).with(body: attrs.to_json).to_return(body: fixture)
      response = resource.save attrs
      expect(response).to be_success

      sms = response.content.first
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
