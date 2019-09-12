require 'spec_helper'

describe InvisibleCollector::Resources::EmailResource do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#find' do

    it 'returns an empty list' do
      fixture = voice_fixture('email/find_empty')
      stub_do_voice("/email/find").to_return(body: fixture)
      response = resource.find()
      expect(response).to be_success

      emails = response.content
      expect(emails).to be_kind_of(InvisibleCollector::Model::EmailList)
      expect(emails.total_records).to eq(0)
      expect(emails.records).to be_empty
    end

    [ { 'smtp-id' => 234} ].each do |query|
      it "returns an email when using query '#{query}'" do
        fixture = voice_fixture('email/find')
        parsed  = JSON.load(fixture)
        stub_do_voice("/email/find?#{URI.encode_www_form(query)}").to_return(body: fixture)
        response = resource.find query
        expect(response).to be_success

        emails = response.content
        expect(emails).to be_kind_of(InvisibleCollector::Model::EmailList)
        expect(emails.total_records).to eq(1)

        email = emails.records.first
        expect(email).to be_kind_of(InvisibleCollector::Model::Email)

        expect(email.id).to eq(parsed['records'][0]['gid'])
        expect(email.destination).to eq(parsed['records'][0]['destination'])
        expect(email.status).to eq(parsed['records'][0]['status'])
        expect(email.events.size).to eq(parsed['records'][0]['events'].size)
        expect(email.events.first['description']).to eq(parsed['records'][0]['events'].first['description'])
        expect(email.events.first['event']).to eq(parsed['records'][0]['events'].first['event'])
        expect(email.events.first['created_at']).to eq(parsed['records'][0]['events'].first['createdAt'])
      end
    end
  end
end
