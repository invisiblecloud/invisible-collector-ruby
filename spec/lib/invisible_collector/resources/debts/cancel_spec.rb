require 'spec_helper'

describe InvisibleCollector::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#cancel' do

    { invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Debt not found' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Debt already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest,
                       message: 'Unprocessable request' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("debt/#{key}")
        stub_do_api('/debts/id/cancel', :put).to_return(body: fixture, status: attrs[:code])
        expect do
          resource.cancel 'id'
        end.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'cancels a debt when given an external id' do
      fixture = api_fixture('debt/cancel')
      parsed  = JSON.parse(fixture)

      stub_do_api('/debts/id/cancel', :put).to_return(body: fixture)
      debt = resource.cancel 'id'

      expect(debt).to be_kind_of(InvisibleCollector::Debt)

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
      parsed  = JSON.parse(fixture)

      debt = InvisibleCollector::Debt.new external_id: 'id'

      stub_do_api('/debts/id/cancel', :put).to_return(body: fixture)
      debt = resource.cancel(debt)

      expect(debt).to be_kind_of(InvisibleCollector::Debt)

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
end
