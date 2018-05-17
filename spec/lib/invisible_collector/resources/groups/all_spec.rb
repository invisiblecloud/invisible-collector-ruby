require 'spec_helper'

describe InvisibleCollector::GroupResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#all' do

    {
        invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
        unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
        not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Group not found' },
        conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Group already registered' },
        unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("group/#{key}")
        stub_do_api('/groups', :get).to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.all(params)
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'returns an empty list' do
      fixture = api_fixture('group/all_empty')
      stub_do_api("/groups").to_return(body: fixture)
      groups = resource.all()

      expect(groups).to be_kind_of(Array)
      expect(groups).to be_empty
    end
  end
end
