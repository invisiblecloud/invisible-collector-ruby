require 'spec_helper'

describe InvisibleCollector::Resources::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#find' do

    it 'returns an empty list' do
      fixture = api_fixture('debt/find_empty')
      stub_do_api("/debts/find").to_return(body: fixture)
      response = resource.find()
      expect(response).to be_success

      debts = response.content
      expect(debts).to be_kind_of(Array)
      expect(debts).to be_empty
    end

    [ { 'number' => 234},
      { number: 3242},
      { as: '234123', number: '32421' },
      { from_date: 'dsfasdf', to_date: 'dsfasdfsd' } ].each do |query|

      it "returns a debt when using query '#{query}'" do
        fixture = api_fixture('debt/find')
        parsed  = JSON.load(fixture).first
        stub_do_api("/debts/find?#{URI.encode_www_form(query)}").to_return(body: fixture)
        response = resource.find query
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

end
