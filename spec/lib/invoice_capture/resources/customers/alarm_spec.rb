require 'spec_helper'

describe InvoiceCapture::CustomerResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#alarm' do

    {
      invalid: { code: 400, exception: InvoiceCapture::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvoiceCapture::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvoiceCapture::InvalidRequest, message: 'Customer already registered' },
      unprocessable: { code: 422, exception: InvoiceCapture::InvalidRequest, message: 'Unprocessable request' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("customer/#{key}")
        stub_do_api("/customers/something/alarm").to_return(body: fixture, status: attrs[:code])
        params = {}
        expect {
          resource.alarm('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end

    end

    it 'returns null if not found' do
      fixture = api_fixture('customer/alarm')
      stub_do_api("/customers/something/alarm").to_return(body: fixture, status: 404)
      alarm = resource.alarm('something')

      expect(alarm).to be_nil
    end

    it 'returns an alarm' do
      fixture = api_fixture('customer/alarm')
      parsed  = JSON.load(fixture)

      stub_do_api("/customers/something/alarm").to_return(body: fixture)
      alarm = resource.alarm('something')

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

end
