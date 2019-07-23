require 'spec_helper'

describe InvisibleCollector::Resources::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#unsuspend' do

    { invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Debt not found' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Debt already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest,
                       message: 'Unprocessable request' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("debt/#{key}")
        stub_do_api('/debts/id/unsuspend', :put).to_return(body: fixture, status: attrs[:code])
        expect do
          resource.unsuspend 'id'
        end.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'unsuspends a debt when given an id' do
      fixture = api_fixture('debt/unsuspend')
      parsed  = JSON.parse(fixture)

      stub_do_api('/debts/id/unsuspend', :put).to_return(body: fixture)
      response = resource.unsuspend 'id'
      expect(response).to be_success

      debt = response.content
      expect(debt).to be_kind_of(InvisibleCollector::Model::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq('PENDING')
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.paid_at).to eq(parsed['paidAt'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
    end

    it 'unsuspends a debt when given a debt object' do
      fixture = api_fixture('debt/unsuspend')
      parsed  = JSON.parse(fixture)

      debt = InvisibleCollector::Model::Debt.new id: 'id'

      stub_do_api('/debts/id/unsuspend', :put).to_return(body: fixture)
      response = resource.unsuspend(debt)
      expect(response).to be_success

      debt = response.content
      expect(debt).to be_kind_of(InvisibleCollector::Model::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq('PENDING')
      expect(debt.date).to eq(parsed['date'])
      expect(debt.due_date).to eq(parsed['dueDate'])
      expect(debt.paid_at).to eq(parsed['paidAt'])
      expect(debt.net_total).to eq(parsed['netTotal'])
      expect(debt.tax).to eq(parsed['tax'])
      expect(debt.gross_total).to eq(parsed['grossTotal'])
      expect(debt.paid_total).to eq(parsed['paidTotal'])
    end

    it 'unsuspends a debt when given a hash' do
      fixture = api_fixture('debt/unsuspend')
      parsed  = JSON.parse(fixture)

      stub_do_api('/debts/id/unsuspend', :put).to_return(body: fixture)
      response = resource.unsuspend(id: 'id')
      expect(response).to be_success

      debt = response.content
      expect(debt).to be_kind_of(InvisibleCollector::Model::Debt)

      expect(debt.number).to eq(parsed['number'])
      expect(debt.external_id).to eq(parsed['externalId'])
      expect(debt.type).to eq(parsed['type'])
      expect(debt.status).to eq('PENDING')
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
