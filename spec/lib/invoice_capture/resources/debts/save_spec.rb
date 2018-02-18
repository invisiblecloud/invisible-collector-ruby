require 'spec_helper'

describe InvoiceCapture::DebtResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save' do

    it 'fails on json error' do
      fixture = api_fixture('debt/invalid')
      stub_do_api("/debts", :post).with(body: '{}').to_return(body: fixture, status: 400)
      attrs = {}
      expect {
        resource.save attrs
      }.to raise_exception(InvoiceCapture::InvalidRequest).with_message('400: Invalid JSON')
    end

    it 'fails on conflict' do
      fixture = api_fixture('debt/conflict')
      stub_do_api("/debts", :post).with(body: '{}').to_return(body: fixture, status: 409)
      attrs = {}
      expect {
        resource.save attrs
      }.to raise_exception(InvoiceCapture::InvalidRequest).with_message('409: Debt already registered')
    end

    it 'fails on invalid request' do
      fixture = api_fixture('debt/wrong_arguments')
      stub_do_api("/debts", :post).with(body: '{}').to_return(body: fixture, status: 422)
      attrs = {}
      expect {
        resource.save attrs
      }.to raise_exception(InvoiceCapture::InvalidRequest).with_message('422: Debt already registered')
    end

    it 'uses a debt object' do
      fixture = api_fixture('debt/save')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', external_id: 'sfsdfsad', type: 'SD', status: 'PENDING' }
      debt = InvoiceCapture::Debt.new(attrs)
      stub_do_api('/debts', :post).with(body: debt.to_json).to_return(body: fixture)
      debt = resource.save debt

      expect(debt).to be_kind_of(InvoiceCapture::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq(parsed['status'])
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
    end

    it 'uses a debt hash' do
      fixture = api_fixture('debt/save')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', external_id: 'sfsdfsad', type: 'SD', status: 'PENDING' }
      stub_do_api('/debts', :post).with(body: attrs.to_json).to_return(body: fixture)
      debt = resource.save attrs

      expect(debt).to be_kind_of(InvoiceCapture::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq(parsed['status'])
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
    end

  end

end
