require 'spec_helper'

describe InvisibleCollector::Resources::CustomerResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save' do

    it 'fails on conflict' do
      fixture = api_fixture('customer/conflict')
      stub_do_api("/customers").with(body: '{}').to_return(body: fixture, status: 409)
      expect {
        resource.save
      }.to raise_exception(InvisibleCollector::InvalidRequest).with_message('409: Customer already registered')
    end

    it 'returns the created customer using a hash' do
      fixture = api_fixture('customer/post')
      parsed  = JSON.load(fixture)

      stub_do_api("/customers", :post).with(body: '{}').to_return(body: fixture)
      response = resource.save
      expect(response).to be_success

      customer = response.content
      expect(customer).to be_kind_of(InvisibleCollector::Model::Customer)

      expect(customer.name).to eq(parsed['name'])
      expect(customer.vat_number).to eq(parsed['vatNumber'])
      expect(customer.address).to eq(parsed['address'])
      expect(customer.zip_code).to eq(parsed['zipCode'])
      expect(customer.city).to eq(parsed['city'])
      expect(customer.country).to eq(parsed['country'])
      expect(customer.phone).to eq(parsed['phone'])
      expect(customer.email).to eq(parsed['email'])
      expect(customer.mobile).to eq(parsed['mobile'])
      expect(customer.gid).to eq(parsed['gid'])
      expect(customer.external_id).to eq(parsed['externalId'])
    end

    it 'returns the created customer using customer object' do
      fixture = api_fixture('customer/post')
      parsed  = JSON.load(fixture)
      new_customer = InvisibleCollector::Model::Customer.new parsed

      stub_do_api("/customers", :post).with(body: new_customer.to_json).to_return(body: fixture)
      response = resource.save(new_customer)
      expect(response).to be_success

      customer = response.content
      expect(customer).to be_kind_of(InvisibleCollector::Model::Customer)

      expect(customer.name).to eq(parsed['name'])
      expect(customer.vat_number).to eq(parsed['vatNumber'])
      expect(customer.address).to eq(parsed['address'])
      expect(customer.zip_code).to eq(parsed['zipCode'])
      expect(customer.city).to eq(parsed['city'])
      expect(customer.country).to eq(parsed['country'])
      expect(customer.phone).to eq(parsed['phone'])
      expect(customer.mobile).to eq(parsed['mobile'])
      expect(customer.email).to eq(parsed['email'])
      expect(customer.gid).to eq(parsed['gid'])
      expect(customer.external_id).to eq(parsed['externalId'])
    end
  end
end
