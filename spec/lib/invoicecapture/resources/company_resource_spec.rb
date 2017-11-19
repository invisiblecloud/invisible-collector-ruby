require 'spec_helper'

describe InvoiceCapture::CompanyResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns the company info' do
      fixture = api_fixture('company/get')
      parsed  = JSON.load(fixture)

      stub_do_api('').to_return(body: fixture)
      company = resource.get

      expect(company.name).to eq("Johny's Company")
    end

  end

  describe '#update' do

    it 'updates the company info' do
      company_info = resource.update
    end

  end

  describe '#enable_notifications' do

    it 'enables notifications' do
      company_info = resource.enable_notifications
    end

  end

  describe '#disable_notifications' do

    it 'disables notifications' do
      company_info = resource.disable_notifications
    end

  end

end
