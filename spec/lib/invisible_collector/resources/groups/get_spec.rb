require 'spec_helper'

describe InvisibleCollector::Resources::GroupResource do
  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do
    { unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound,
                   message: 'Group not found' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("group/#{key}")
        gid = SecureRandom.uuid
        stub_do_api("/groups/#{gid}", :get).to_return(body: fixture, status: attrs[:code])
        expect { resource.get!(gid) }.to(raise_exception(attrs[:exception])
                                             .with_message("#{attrs[:code]}: #{attrs[:message]}"))
      end
    end

    it 'returns the group info' do
      fixture = api_fixture('group/get')
      parsed  = JSON.parse(fixture)

      stub_do_api('/groups/id').to_return(body: fixture)
      group = resource.get! 'id'

      expect(group).to be_kind_of(InvisibleCollector::Group)

      expect(group.id).to eq(parsed['id'])
      expect(group.name).to eq(parsed['name'])
    end
  end
end
