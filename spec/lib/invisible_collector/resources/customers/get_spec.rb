require 'spec_helper'

describe InvisibleCollector::CustomerResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns null if not found' do
      fixture = api_fixture('customer/not_found')
      stub_do_api("/customers/something").to_return(body: fixture, status: 404)
      customer = resource.get('something')

      expect(customer).to be_nil
    end

    it 'returns the customer info using gid' do
      fixture = api_fixture('customer/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/customers/#{parsed['gid']}").to_return(body: fixture)
      customer = resource.get(parsed['gid'])

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

  describe '#get!' do

    it 'fails if not found' do
      fixture = api_fixture('customer/not_found')
      stub_do_api("/customers/something").to_return(body: fixture, status: 404)
      expect {
        resource.get!('something')
      }.to raise_exception(InvisibleCollector::NotFound).with_message('404: Customer not found')
    end

    it 'returns the customer info using gid' do
      fixture = api_fixture('customer/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/customers/#{parsed['gid']}").to_return(body: fixture)
      customer = resource.get!(parsed['gid'])

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
