require 'spec_helper'

describe InvisibleCollector::CustomerResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#find' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Customer already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("customer/#{key}")
        stub_do_api("/customers/find").to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.find()
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'returns an empty list' do
      fixture = api_fixture('customer/find_empty')
      stub_do_api("/customers/find").to_return(body: fixture)
      customers = resource.find()

      expect(customers).to be_kind_of(Array)
      expect(customers).to be_empty
    end

    [
      {"phone" => 234},
      {phone: 3242},
      {as: '234123', email: 'sfasfsd', phone: '32421'}
    ].each do |query|

      it "returns a customer when using query '#{query}'" do
        fixture = api_fixture('customer/find')
        parsed  = JSON.load(fixture).first
        stub_do_api("/customers/find?#{URI.encode_www_form(query)}").to_return(body: fixture)
        customers = resource.find query

        expect(customers).to be_kind_of(Array)
        expect(customers.size).to eq(1)

        customer = customers.first
        expect(customer).to be_kind_of(InvisibleCollector::Customer)

        expect(customer.name).to eq(parsed['name'])
        expect(customer.vat_number).to eq(parsed['vatNumber'])
        expect(customer.address).to eq(parsed['address'])
        expect(customer.zip_code).to eq(parsed['zipCode'])
        expect(customer.city).to eq(parsed['city'])
        expect(customer.country).to eq(parsed['country'])
        expect(customer.phone).to eq(parsed['phone'])
        expect(customer.email).to eq(parsed['email'])
        expect(customer.gid).to eq(parsed['gid'])
        expect(customer.external_id).to eq(parsed['externalId'])
      end
    end

  end

end
