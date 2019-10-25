require 'spec_helper'

describe InvisibleCollector::Resources::CustomerResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#debts' do

    {
      invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized, message: 'Credentials are required to access this resource' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Customer already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest, message: 'Unprocessable request' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Customer not found' }
    }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("customer/#{key}")
        stub_do_api("/customers/something/debts").to_return(body: fixture, status: attrs[:code])
        expect {
          resource.debts('something')
        }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'returns an empty list' do
      fixture = api_fixture('customer/empty_debts')
      stub_do_api("/customers/something/debts").to_return(body: fixture)
      response = resource.debts('something')
      expect(response).to be_success

      debts = response.content
      expect(debts).to be_kind_of(Array)
      expect(debts).to be_empty
    end

    it 'returns a debt' do
      fixture = api_fixture('customer/debts')
      parsed  = JSON.load(fixture).first
      stub_do_api("/customers/something/debts").to_return(body: fixture)
      response = resource.debts('something')
      expect(response).to be_success

      debts = response.content
      expect(debts).to be_kind_of(Array)
      expect(debts.size).to eq(1)

      debt = debts.first
      expect(debt).to be_kind_of(InvisibleCollector::Model::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq(parsed['status'])
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.paid_at).to eq(parsed['paidAt'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
      expect(debt.paid_total).to eq(parsed['paidTotal'])
      expect(debt.debit_total).to eq(parsed['debitTotal'])
    end
  end
end
