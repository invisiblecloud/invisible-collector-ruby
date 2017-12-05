require 'spec_helper'

describe InvoiceCapture::DebtResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#cancel' do

    it 'fails if the debt does not exist' do
      fixture = api_fixture('debt/not_found')
      stub_do_api('/debts/id/cancel', :put).to_return(body: fixture, status: 404)
      expect {
        resource.cancel 'id'
      }.to raise_exception(InvoiceCapture::NotFound).with_message('404: Debt not found')
    end

    it 'cancels a debt when given an external id' do
      fixture = api_fixture('debt/cancel')
      parsed  = JSON.load(fixture)

      stub_do_api('/debts/id/cancel', :put).to_return(body: fixture)
      debt = resource.cancel 'id'

      expect(debt).to be_kind_of(InvoiceCapture::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq('CANCELLED')
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
    end

    it 'cancels a debt when given a debt object' do
      fixture = api_fixture('debt/cancel')
      parsed  = JSON.load(fixture)

      debt = InvoiceCapture::Debt.new external_id: 'id'

      stub_do_api('/debts/id/cancel', :put).to_return(body: fixture)
      debt = resource.cancel(debt)

      expect(debt).to be_kind_of(InvoiceCapture::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq('CANCELLED')
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
    end

  end

  describe '#find' do

    it 'returns an empty list' do
      fixture = api_fixture('debt/find_empty')
      stub_do_api("/debts/find").to_return(body: fixture)
      debts = resource.find()

      expect(debts).to be_kind_of(Array)
      expect(debts).to be_empty
    end

    [
      {"number" => 234},
      {number: 3242},
      {as: '234123', number: '32421'}
    ].each do |query|

      it "returns a debt when using query '#{query}'" do
        fixture = api_fixture('debt/find')
        parsed  = JSON.load(fixture).first
        stub_do_api("/debts/find?#{URI.encode_www_form(query)}").to_return(body: fixture)
        debts = resource.find query

        expect(debts).to be_kind_of(Array)
        expect(debts.size).to eq(1)

        debt = debts.first
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

  describe '#get' do

    it 'returns the debt info' do
      fixture = api_fixture('debt/get')
      parsed  = JSON.load(fixture)

      stub_do_api('/debts/id').to_return(body: fixture)
      debt = resource.get 'id'

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

  describe '#save' do

    it 'fails on json error' do
      fixture = api_fixture('debt/invalid_json')
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
