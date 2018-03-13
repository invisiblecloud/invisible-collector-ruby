require 'spec_helper'

describe InvoiceCapture::CustomerResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#update' do

    {
      invalid: { code: 400, exception: InvoiceCapture::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvoiceCapture::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvoiceCapture::InvalidRequest, message: 'Customer already registered' },
      unprocessable: { code: 422, exception: InvoiceCapture::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("customer/#{key}")
        customer = { gid: 'xpto' }
        stub_do_api('/customers/xpto', :put).with(body: customer).to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.update(customer)
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'using a customer hash' do
      fixture = api_fixture('customer/update')
      parsed  = JSON.load(fixture)

      customer = InvoiceCapture::Customer.new
      stub_do_api("/customers/#{customer.gid}", :put).with(body: customer.to_json).to_return(body: fixture)
      customer = resource.update customer.to_h

      expect(customer).to be_kind_of(InvoiceCapture::Customer)

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

    it 'using a customer object' do
      fixture = api_fixture('customer/update')
      parsed  = JSON.load(fixture)

      customer = InvoiceCapture::Customer.new
      stub_do_api("/customers/#{customer.gid}", :put).with(body: customer.to_json).to_return(body: fixture)
      customer = resource.update customer

      expect(customer).to be_kind_of(InvoiceCapture::Customer)

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
