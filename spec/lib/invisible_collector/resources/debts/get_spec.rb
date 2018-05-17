require 'spec_helper'

describe InvisibleCollector::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns the debt info' do
      fixture = api_fixture('debt/get')
      parsed  = JSON.load(fixture)

      stub_do_api('/debts/id').to_return(body: fixture)
      debt = resource.get 'id'

      expect(debt).to be_kind_of(InvisibleCollector::Debt)

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

    it 'returns the debits' do
      fixture = api_fixture('debt/get_debits')
      parsed  = JSON.load(fixture)

      stub_do_api('/debts/id').to_return(body: fixture)
      debt = resource.get 'id'

      expect(debt).to be_kind_of(InvisibleCollector::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq(parsed['status'])
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
      expect(debt.debits.size).to eq(parsed['debits'].size)
      debt.debits.zip(parsed['debits']).each do |actual, expected|
        expect(actual[:number]).to eq(expected['number'])
      end
    end

  end

end
